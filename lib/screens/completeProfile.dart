import 'dart:io';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({super.key, required this.userModel, required this.firebaseUser});
  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  File? img;
  TextEditingController nameController = TextEditingController();

  void selectImg(ImageSource source) async{
    XFile? pickedFile =  await ImagePicker().pickImage(source: source);

    if(pickedFile != null){
      cropImg(pickedFile);
    }
  }

  void cropImg(XFile cropfile) async{
    CroppedFile? croppedImg = await ImageCropper().cropImage(
      sourcePath: cropfile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20
      );

    if(croppedImg != null){
      setState(() {
        img = File(croppedImg.path);
      });
    }
  }

  void showInputImgOptions(){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImg(ImageSource.gallery);
              },
              leading: const Icon(Icons.photo_album),
              title: const Text("Select from Gallery"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImg(ImageSource.camera);
              },
              leading: const Icon(Icons.camera),
              title: const Text("Take photo"),
            ),
          ],
        ),
      );
    });    
  }

  void checkValues(){
    String name = nameController.text.trim();

    if(name == "" || img == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enter Details')));
    }
    else {
      uploadData();
    }
  }

  void uploadData() async{
    UploadTask uploadTask = FirebaseStorage.instance.ref("profilePictures").child(widget.userModel.uid.toString()).putFile(img!);
    TaskSnapshot snapshot = await uploadTask;
    String imgurl = await snapshot.ref.getDownloadURL();
    String name = nameController.text.trim();

    widget.userModel.name = name; 
    widget.userModel.profilePic = imgurl; 

    await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value) {
      print("Data Uploaded");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context){
            return Home_Page(firebaseUser: widget.firebaseUser, userModel: widget.userModel);
          })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: ListView(
            children: [
              CupertinoButton(
                onPressed: () {
                  showInputImgOptions();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade500,
                  foregroundColor: Colors.white,
                  backgroundImage: img != null? FileImage(img!): null,
                  radius: 50,
                  child: img == null? const Icon(Icons.person, size: 70,): null,
                ),
              ),
              20.heightBox,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                  ),
                )
              ),

              20.heightBox,
              CupertinoButton(
                color: Colors.green.shade500,
                onPressed: (){
                  checkValues();
                },
                child: "Submit".text.make(),
                )
            ],
          ),
        ),
      ),
    );
  }
}