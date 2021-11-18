import 'package:flutter/material.dart';

class MyDialog {
  static void setContentDialog({ required String title,  required String message,  required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              elevation: 20,
              shape: ContinuousRectangleBorder(side: const BorderSide(color: Colors.blueAccent), borderRadius: BorderRadius.circular(30)),
              title: Text(title),
              content: Text(message));
        });
  }
}
