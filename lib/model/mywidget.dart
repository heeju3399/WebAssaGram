import 'package:flutter/material.dart';

class MyWidget {
  static Color tileColor = Colors.white12;
  static Color textColor = Colors.white;
  static Color iconColor = Colors.white60;
  static Color backgroundColor = Colors.white12;
  static double basicFontSize = 25.0;
  static Text myTextWhite(String value){
    return Text(value, style: const TextStyle(color: Colors.white));
  }

  static Text myTextBlack(String value){
    return Text(value, style: const TextStyle(color: Colors.black));
  }



}
