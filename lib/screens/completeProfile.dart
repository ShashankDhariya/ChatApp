import 'package:chat_app/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              CupertinoButton(
                onPressed: () {

                },
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade500,
                  foregroundColor: Colors.white,
                  radius: 50,
                  child: Icon(Icons.person, size: 70,),
                ),
              ),
              20.heightBox,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                  ),
                )
              ),

              20.heightBox,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                )
              ),

              20.heightBox,
              CupertinoButton(
                color: Colors.green.shade500,
                onPressed: (){
                  
                },
                child: "Sign Up".text.make(),
                )
            ],
          ),
        ),
      ),
    );
  }
}