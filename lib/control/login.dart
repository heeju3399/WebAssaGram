

import 'package:realproject/server/nodeserver.dart';

class LoginControl {
  static Future<Map> checkIdAndPass(String id, String pass) async {
    String resultTitle = '';
    String resultMessage = '';
    int resultStateCode = 0;
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

    if (id == '' || id.isEmpty || pass == '' || pass.isEmpty) {
      resultMap = {'title': '빈칸을 채워주세요', 'message': '아이디와 비밀번호를 입력해 주세요'};
    } else {
      bool idCheck = isKorean(id);
      bool passCheck = isKorean(pass);
      if(!idCheck && !passCheck){
        await NodeServer.signIn(id, pass).then((value) =>
        {resultTitle = value.title, resultMessage = value.message,
          resultStateCode = value.stateCode});
        if (resultTitle == 'pass') {
          //로그인 됨
          resultMap = {'title': resultTitle, 'message': resultMessage};
        } else if (resultTitle == 'no') {
          //로근인 안됨
          resultMap = {'title': '회원정보가 없습니다', 'message': '아이디와 비밀번호를 확인해 주세요'};
        } else {
          resultMap = {'title': resultTitle, 'message': resultMessage};
        }
      }else{//한글이 있을경우
        resultMap = {'title': '입력 오류', 'message': '영어와 숫자만 입력해주세요'};
      }
    }
    return resultMap;
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
