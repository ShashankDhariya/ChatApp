import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, 
          MaterialPageRoute(builder: (context){
            return Search_Page(userModel: widget.userModel, firebaseuser: widget.firebaseUser,);
          }));
        },
        child: Icon(Icons.search),
      ),
      body: Column(
        children: [
          Text(widget.userModel.email.toString()),
        ],
      )
    );
  }
}