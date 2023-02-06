import 'package:chat_app/screens/login.dart';
import 'package:chat_app/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:pinput/pinput.dart';

class Verification_Page extends StatelessWidget {
  Verification_Page({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed:() {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )
          ),
      ),
      body: Container(
        margin: const EdgeInsets.all(25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/otpImg.png'),
            
              "Verification".text.xl3.bold.make(),
              10.heightBox,
              "Enter OTP".text.center.xl.make(),
              20.heightBox,

              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
              ),

              15.heightBox,
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:() async {
                    try{
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: Login_Page.verify,
                        smsCode: code,
                      );
                      await auth.signInWithCredential(credential);
                      Navigator.pushNamedAndRemoveUntil(context, MyRoutes.homeRoute, (route) => false);
                    }catch(e){
                      print('Wrong OTP');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    )
                  ),
                  child: "Verify OTP".text.make(),
                )
              ),
              TextButton(
                onPressed:() {
                  Navigator.pushNamed(context, MyRoutes.loginRoute);
                }, 
                child: "Edit phone number".text.gray700.make()
              ).objectTopLeft(),
            ],
          ),
        ),
      ),
    );
  }
}