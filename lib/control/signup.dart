
import 'package:realproject/server/nodeserver.dart';

class SignUpController {
  static Future<Map> checkIdAndPassAndName({ String id,  String pass,  String name}) async {
    String resultTitle = '';
    String resultMessage = '';
    int resultStateCode2 = 0;
    Map resultMap = Map();
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

    if (id == '' || id.isEmpty || pass == '' || pass.isEmpty || name.isEmpty) {
      resultMap = {'title': '빈칸을 채워주세요', 'message': '아이디와 비밀번호, 이름을 입력해 주세요'};
    } else {
      bool idCheck = isKorean(id);
      bool passCheck = isKorean(pass);
      bool nameCheck = isKorean(name);
      if (!idCheck && !passCheck && !nameCheck) {
        await NodeServer.signUp(id: id, name: name, pass: pass).then((value) => {resultTitle = value.title, resultMessage = value.message, resultStateCode2 = value.stateCode});

        if (resultTitle == 'doubleCheck') {
          //회원가입 안됨이유는 아이디 중복
          resultMap = {'title': resultTitle, 'message': resultMessage};
        } else if (resultTitle == 'no') {
          //회원가입 뭔가모를 에러로 안됨
          resultMap = {'title': resultTitle, 'message': resultMessage};
        } else if (resultTitle == 'pass') {
          //ok
          resultMap = {'title': resultTitle, 'message': resultMessage};
        } else {
          resultMap = {'title': resultTitle, 'message': resultMessage};
        }
      } else {
        resultMap = {'title': '입력 오류', 'message': '영어와 숫자만 입력해주세요'};
      }
    }

    return resultMap;
  }
}
