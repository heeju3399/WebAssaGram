import 'package:web/server/nodeserver.dart';

// ignore_for_file: avoid_print
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
}
