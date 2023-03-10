// ignore: unused_import
import 'package:chat_app/screens/signup.dart';
import 'package:chat_app/utils/routes.dart';
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
  @override

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == ""){
      print("Enter your details");
    }
    else {
      login(email, password);
    }
  }

  Future<void> login(String email, String password) async {
    try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password
  );
  Navigator.pushNamed(context, MyRoutes.homeRoute);
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(25),
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
                Navigator.pushNamed(context, MyRoutes.signupRoute);
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