import 'package:chat_app/screens/completeProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_app/models/UserModel.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({super.key});

  @override
  State<Signup_page> createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();

    if(email == "" || password == "" || cpassword == ""){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your details")));
    }
    else if(password != cpassword){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password don't match")));
    }
    else {
      signup(email, password);
    }
  }

  void signup(String email, String password) async{
    UserCredential? credential;
    try {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );
    } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
    }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
}
    if(credential != null){
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        name: "",
        profilePic: "",
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context){
              return CompleteProfile(userModel: newUser, firebaseUser: credential!.user!);
            }
            )
          );
        } 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loginImg.png', width: 270, height: 200,),
              "Register".text.xl3.bold.make(),
              20.heightBox,

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Enter Email"
                ),
              ),
              15.heightBox,
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Enter Password"
                ),
              ),
              15.heightBox,
              TextFormField(
                controller: cpasswordController,
                decoration: const InputDecoration(
                  hintText: "Confirm Password"
                ),
              ),

              20.heightBox,
              CupertinoButton(
                color: Colors.green.shade500,
                onPressed:() {
                  checkValues();
                },
                child: "Register".text.xl.make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}