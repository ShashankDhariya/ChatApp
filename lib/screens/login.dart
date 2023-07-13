import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});
  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == ""){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enter Details')));
    }
    else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  
  if(credential != null){
    String uid = credential.user!.uid;

    DocumentSnapshot userData = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context){
          return Home_Page(userModel: userModel, firebaseUser: credential!.user!);
        }
      ),
    );
  }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
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
              "Login".text.xl3.bold.make(),
              20.heightBox,

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Enter Email",
                ),
              ),
              15.heightBox,
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Enter Password"
                ),
              ),

              20.heightBox,
              CupertinoButton(
                color: Colors.green.shade500,
                onPressed:() {
                  checkValues();
                },
                child: "Login".text.xl.make(),
              ),
              "Don't have an account?".text.make(),
              TextButton(onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(
                  builder: (context){
                    return const Signup_page();
                  })
                );
              },
              child: "Sign up".text.underline.make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}