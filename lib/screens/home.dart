import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/models/ChatRoom.dart';
import 'package:chat_app/models/firebaseHelper.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/chatAi.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Home_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  
  const Home_Page({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "VartaApp".text.make(),
        actions: [
          IconButton(
            onPressed:() {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context){
                  return Search_Page(userModel: widget.userModel, firebaseuser: widget.firebaseUser,);
                }));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed:() async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder:(context) {
                    return const Login_Page();
                  },
                )
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, 
          MaterialPageRoute(builder: (context){
            return const ChatGPT();
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: const [
              Icon(CupertinoIcons.chat_bubble_text),
              Text("Chat with AI", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).snapshots(),
          builder:(context, snapshot) {
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                QuerySnapshot chatroomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: chatroomSnapshot.docs.length,
                  itemBuilder:(context, index) {
                    ChatRoom chatRoomModel = ChatRoom.fromMap(chatroomSnapshot.docs[index].data() as Map<String, dynamic>);
                    Map<String, dynamic> participants = chatRoomModel.participants!;

                    List<String> participantKeys = participants.keys.toList();
                    participantKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future: FirebaseHelper.getuserModelById(participantKeys[0]),
                      builder: (context, userData) {
                        if(userData.connectionState == ConnectionState.done){
                          if(userData.data != null){
                            UserModel targetuser = userData.data as UserModel;
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:(context) {
                                      return chat(targetuser: targetuser, chatroom: chatRoomModel, usermodel: widget.userModel, firebaseUser: widget.firebaseUser);
                                    },
                                  )
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(targetuser.profilePic.toString()),
                              ),
                                title: Text(targetuser.name.toString()),
                                subtitle: (chatRoomModel.lastMessage.toString() != "")? SizedBox(height: 15,child: Text(chatRoomModel.lastMessage.toString())) : const Text("Say hi!"),
                            );
                          }
                          else{
                            return Container();
                          }
                        }
                        else{
                          return Container();
                        }
                      },
                    );
                  },
                );
              }
              else if(snapshot.hasError){
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              else{
                return const Center(
                  child: Text("Start chatting..."),
                );
              }
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      )
    );
  }
}