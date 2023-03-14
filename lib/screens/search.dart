import 'package:chat_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search_Page extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const Search_Page({super.key, required this.userModel, required this.user});

  @override
  State<Search_Page> createState() => _Search_PageState();
}

class _Search_PageState extends State<Search_Page> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}