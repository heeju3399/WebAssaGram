import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/model/myWord.dart';

class MyShared {

  String userId = '';

  void setUserId(String userId) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString(MyWord.USERID, userId);
  }

  Future<String> getUserId() async {
    String result = MyWord.LOGIN;
    SharedPreferences sh = await SharedPreferences.getInstance();
    if (sh.containsKey(MyWord.USERID)) {
      if (sh.getString(MyWord.USERID).toString() != '' && sh.getString(MyWord.USERID).toString().isNotEmpty) {
        result = sh.getString(MyWord.USERID).toString();
        userId = result;
      }
    }
    return result;
  }
}
