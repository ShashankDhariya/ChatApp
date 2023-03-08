import 'package:chat_app/screens/completeProfile.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:chat_app/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: MyRoutes.loginRoute,
        routes: {
          MyRoutes.loginRoute:(context) => Login_Page(),
          MyRoutes.signupRoute:(context) => Signup_page(),
          MyRoutes.completeProfileRoute: (context) => CompleteProfile(),
          MyRoutes.homeRoute:(context) => Home_Page(),
        },
      );
  }
}

