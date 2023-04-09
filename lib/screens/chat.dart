import 'package:chat_app/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/ChatRoom.dart';
import 'package:chat_app/models/UserModel.dart';
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
  TextEditingController msgController = TextEditingController();
  
  void sendMessage() async{
    String msg = msgController.text.trim();
    msgController.clear();
    if(msg != ""){
      Message newmsg = Message(
        messageid: Uuid().v1(),
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
      print("Message Sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
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
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (currentMsg.sender == widget.usermodel.uid)? Colors.amberAccent :  Colors.greenAccent,
                                  ),
                                  child: Text(currentMsg.text.toString())
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
                      return Center(
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
                      padding: EdgeInsets.all(12.0),
                      child: TextField(
                        controller: msgController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Enter Message",
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed:() {
                      sendMessage();
                    }, 
                    icon: Icon(Icons.send),
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