

import 'package:flutter/cupertino.dart';

class MouseHoverToggle extends ChangeNotifier{
  bool save = false;

  void boolTure(){
    //print('toggle pass');
    save = true;
    notifyListeners();
  }
  void boolFalse(){
    //print('toggle pass');
    save = false;
    notifyListeners();
  }
}