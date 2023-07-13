import 'package:flutter/material.dart';

class UIHelper {
  
  static void showLoadingDialog(BuildContext context, String title){
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 15,),
          Text(title),
        ],
      ),
    );

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder:(context) {
        return loadingDialog;
      },
    );
  }
}