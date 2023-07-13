import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/ChatRoom.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class chat extends StatefulWidget {
  final UserModel targetuser;
  final ChatRoom chatroom;
  final UserModel usermodel;
  final User firebaseUser;

  const chat({
    Key? key,
    required this.targetuser,
    required this.chatroom,
    required this.usermodel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  SpeechToText speechToText = SpeechToText();
  TextEditingController msgController = TextEditingController();
  var isListening = false;
  
  void sendMessage() async{
    String msg = msgController.text.trim();
    msgController.clear();
    if(msg != ""){
      Message newmsg = Message(
        messageid: const Uuid().v1(),
        sender: widget.usermodel.uid,
        sentTime: DateTime.now(),
        seen: false,
        text: msg,
      );

      // No await so that the msges will be visible while offline
      // Don;t need to wait to see the change
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newmsg.messageid).set(newmsg.toMap());
      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      floatingActionButton:  Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: AvatarGlow(
          endRadius: 20, 
          animate: isListening,
          duration: const Duration(milliseconds: 5000),
          glowColor: Colors.black,
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (details) async {
              if(!isListening){
                var available = await speechToText.initialize();
                if(available){
                  setState(() {
                    isListening = true;
                    speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          msgController.text = result.recognizedWords;
                        });
                      },
                    );
                  });
                }
              }
            },
            onTapUp: (details) {
              setState(() {
                isListening = false;
              });
              speechToText.stop();
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 14,
              child: const Icon(Icons.mic,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(        
        title: Row(
          children: [
            CircleAvatar(backgroundColor:  Colors.grey,
            backgroundImage: NetworkImage(widget.targetuser.profilePic.toString()),
            ),
            10.widthBox,
            Text(widget.targetuser.name.toString()),
          ],
        )
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").orderBy("sentTime", descending: true).snapshots(),
                  builder:(context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active){
                      if(snapshot.hasData){
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder:(context, index) {
                            Message currentMsg = Message.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMsg.sender == widget.usermodel.uid)? MainAxisAlignment.end: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (currentMsg.sender == widget.usermodel.uid)? Colors.grey.shade400 :  Colors.greenAccent.shade100,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(currentMsg.text.toString()),
                                      Text(
                                        "${currentMsg.sentTime!.hour}:${currentMsg.sentTime!.minute.toString()}",
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else if(snapshot.hasError) {
                        return const Center(
                          child: Text("An error occured! Please check your internet connection"),
                        );
                      }
                      else {
                        return const Center(
                          child: Text("Say hi!"),
                        );
                      }
                    }
                    else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),

            Container(
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: msgController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Enter Message",
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:() {
                      sendMessage();
                    }, 
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}