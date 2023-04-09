import 'dart:developer';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/ChatRoom.dart';

class Search_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const Search_Page({super.key, required this.userModel, required this.firebaseuser});

  @override
  State<Search_Page> createState() => _Search_PageState();
}

class _Search_PageState extends State<Search_Page> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoom?> getChatroomModel (UserModel targetuser) async {
    ChatRoom? chatRoomModel;

     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where
    ("participants.${widget.userModel.uid}", isEqualTo: true).where
    ("participants.${targetuser.uid}", isEqualTo: true).get();

    if(snapshot.docs.length > 0){
      var docData =  snapshot.docs[0].data();
      ChatRoom existingChatRoom = ChatRoom.fromMap(docData as Map<String, dynamic>);
      chatRoomModel = existingChatRoom;
    }

    else{
      ChatRoom newChatRoom = ChatRoom(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetuser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatRoom.chatroomid).set(newChatRoom.toMap());
      chatRoomModel = newChatRoom;
      log("New ChatRoom Created");
    }
    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Search".text.make(),
        elevation: 0.1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                ),
              ),
            ),

            25.heightBox,
            CupertinoButton(
              onPressed:() {
                setState(() {});
              },
              color: Theme.of(context).colorScheme.secondary,
              child: "Search".text.make(),
            ),

            25.heightBox,
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("email", isEqualTo: searchController.text).snapshots(),
              builder:(context, snapshot) {
                if(snapshot.connectionState == ConnectionState.active) {
                    if(snapshot.hasData){
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                      if(dataSnapshot.docs.length > 0){
                        Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap:() async {
                            ChatRoom? chatRoomModel =  await getChatroomModel(searchedUser);
                            if(chatRoomModel != null){
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder:(context) {
                                    return chat(
                                      targetuser: searchedUser, 
                                      chatroom: chatRoomModel,
                                      usermodel: widget.userModel, 
                                      firebaseUser: widget.firebaseuser, 
                                    );
                                  },
                                )
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(searchedUser.profilePic!),
                          ),
                          title: Text(searchedUser.name.toString()),
                          subtitle: Text(searchedUser.email.toString()),
                        );
                      }

                      else {
                        return Text("No result found");
                      }
                    }
                    else if(snapshot.hasError){
                      return Text("An error occured");
                    }
                    else {
                      return Text("No result found");
                    }
                }
                else {
                  return CircularProgressIndicator();
                }
              }
            )
          ],
        ),
      ),
    );
  }
}