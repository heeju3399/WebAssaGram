import 'package:web/server/nodeserver.dart';

class UserControl {
  static Future<int> doubleCheck(String id) async {
    int returnBool = 0;
    returnBool = await NodeServer.doubleCheck(id);
    return returnBool;
  }

  static Future<bool> signUp(String id, String pass) async {
    bool returnBool = false;
    bool result = await NodeServer.signUp(id, pass);

    if (result) {
      //데이터 베이스에 잘 드어간것
      returnBool = true;
    } else {
      //서버에서 못받았거나 다른이유!
    }
    return returnBool;
  }

  static Future<bool> googleLogin(String email, String name, String id) async {
    bool returnBool = false;
    bool result = await NodeServer.googleAccessSignIn(email, name, id);
    print('contrill = result $result');
    if (result) {
      //데이터 베이스에 잘 드어간것
      returnBool = true;
    } else {
      //서버에서 못받았거나 다른이유!
    }
    return returnBool;
  }

  static Future<int> logIn(String id, String pass) async {
     int resultStateCode = await NodeServer.signIn(id, pass);
    return resultStateCode;
  }

  bool isKorean(String input) {
    bool isKorean = false;
    int inputToUniCode = input.codeUnits[0];
    isKorean = (inputToUniCode >= 12593 && inputToUniCode <= 12643)
        ? true
        : (inputToUniCode >= 44032 && inputToUniCode <= 55203)
            ? true
            : false;
    return isKorean;
  }
}
