import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/ChatRoom.dart';
import 'package:chat_app/models/UserModel.dart';

class chat extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(        
        title: Text("name"),
      ),
      body: Container(
        child: Column(
          children: [

            Expanded(
              child: Container(),
            ),

            Container(
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Message",
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed:() {
                      
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
