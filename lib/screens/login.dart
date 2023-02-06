import 'package:chat_app/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  static String verify = '';
  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {

  TextEditingController countrycode = TextEditingController();
  var phone;
  @override
  void initState() {
    // TODO: implement initState
    countrycode.text = "+91";
    super.initState();
  }
  @override
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
              "Register".text.xl3.bold.make(),
              10.heightBox,
              "Enter your phone number to register".text.center.xl.make(),
              20.heightBox,

              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),              
                child: Row(
                  children: [
                    10.widthBox,
                    SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: countrycode,
                        decoration: InputDecoration(border: InputBorder.none)
                      ),
                    ),

                    10.widthBox,
                    "|".text.xl3.make(),
                    10.widthBox,

                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          phone = value;
                        },
                        decoration: InputDecoration(border: InputBorder.none, hintText: "Phone")
                      ),
                    )
                  ],
                ),
              ),

              20.heightBox,
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:() async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '${countrycode.text + phone}',
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        Login_Page.verify = verificationId;
                        Navigator.pushNamed(context, MyRoutes.verificationRoute);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      
                    )
                  ),
                  child: "Register".text.make(),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}