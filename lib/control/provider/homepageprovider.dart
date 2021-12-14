import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  List<bool> toggle = [false, false, false, false, false];
  double downCountPlus = 1.0;

  bool save = false;
  int pageFlag = 0;
  List<bool> isMainIconsColor = [true, false, false, false, false];
  bool isFloating = true;
  int loginPageFlag = 0;

  void loginPageChanger(int flag) {
    loginPageFlag = flag;
    notifyListeners();
  }

  void pageChange(int flag) {
    pageFlag = flag;
    for (var i = 0; i < 5; i++) {
      if (flag == i) {
        isMainIconsColor[i] = true;
      } else {
        isMainIconsColor[i] = false;
      }
    }
    if (flag == 0) {
      isFloating = true;
    } else {
      isFloating = false;
    }
    notifyListeners();
  }

  void setDownCountPlus() {
    downCountPlus = downCountPlus + 1.0;
    notifyListeners();
  }

  void setToggle(int index) {
    toggle[index] = true;
    notifyListeners();
  }

  void boolTure() {
    save = true;
    notifyListeners();
  }

  void boolFalse() {
    save = false;
    notifyListeners();
  }
}
