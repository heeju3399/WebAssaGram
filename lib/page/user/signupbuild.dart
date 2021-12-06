import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/control/user.dart';

class SignUpBuild extends StatefulWidget {
  const SignUpBuild({Key? key}) : super(key: key);

  @override
  _SignUpBuildState createState() => _SignUpBuildState();
}

class _SignUpBuildState extends State<SignUpBuild> {
  List<TextEditingController> textEditingSignUpControllerList = [];
  List<FocusNode> focusNodeSignUpList = [];
  List<String> errTextSignUpList = [];
  bool logInCircle = true;
  bool isLoginHover = true;

  bool doubleCheck = false;
  int count = 0;
  bool idErrColor = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    HomePageProvider homePageProvider = Provider.of<HomePageProvider>(context);
    return signUpPage(userProvider, homePageProvider);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      textEditingSignUpControllerList.add(TextEditingController());
      focusNodeSignUpList.add(FocusNode());
      errTextSignUpList.add('');
    }
  }

  Widget signUpPage(UserProvider userProvider, HomePageProvider homePageProvider) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: textEditingSignUpControllerList[0],
              focusNode: focusNodeSignUpList[0],
              autofocus: true,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'ID',
                  errorText: errTextSignUpList[0],
                  labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  suffixStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  errorStyle: TextStyle(fontSize: 15, color: idErrColor ? Colors.blueAccent : Colors.red),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              onSubmitted: (v) {
                returnErrString(userProvider, homePageProvider);
                //focusNodeSignUpList[1].requestFocus();
              },
              onChanged: (v) {
                for(int i=0; i<3; i++){
                  errTextSignUpList[i] = '';
                }
                //print(v);
                if(v.isNotEmpty){
                  bool isko =isKorean(v);
                  print('isko???????? $isko');
                  if(isko){
                    errTextSignUpList[0] = '영문 숫자 특수문자 조합으로 부탁드려요';
                  }else{
                    if (v.length > 3) {
                      print('??');
                      UserControl.doubleCheck(v).then((value) {
                        if (value == 0) {
                          errTextSignUpList[0] = '서버에러입니다 관리자에게 문의하세요';
                          idErrColor = false;
                        } else if (value == 1) {
                          errTextSignUpList[0] = '사용가능 합니다.';
                          idErrColor = true;
                          doubleCheck = true;
                        } else {
                          errTextSignUpList[0] = '사용중인 아이디 입니다.';
                          idErrColor = false;
                          doubleCheck = false;
                        }
                        setState(() {});
                      });
                    } else {
                      errTextSignUpList[0] = '';
                      idErrColor = false;
                    }
                  }
                  setState(() {});
                }else{
                  errTextSignUpList[0] = '';
                  idErrColor = false;
                  setState(() {});
                }
              },
            ),
          )),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: 300,
              child: TextField(
                  obscureText: true,
                  focusNode: focusNodeSignUpList[1],
                  controller: textEditingSignUpControllerList[1],
                  onSubmitted: (v) {
                    //_logInOperation(context);
                    //returnErrString();
                    //focusNodeSignUpList[2].requestFocus();
                    returnErrString(userProvider, homePageProvider);
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'PASS',
                    errorText: errTextSignUpList[1],
                    errorStyle: const TextStyle(fontSize: 15),
                    labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
                    suffixStyle: const TextStyle(fontSize: 15, color: Colors.white),
                    hintStyle: const TextStyle(fontSize: 15, color: Colors.white),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  )))),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: 300,
              child: TextField(
                  obscureText: true,
                  focusNode: focusNodeSignUpList[2],
                  controller: textEditingSignUpControllerList[2],
                  onSubmitted: (v) {
                    //_logInOperation(context);
                    //returnErrString();
                    returnErrString(userProvider, homePageProvider);
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'PASS_CHECK',
                    errorText: errTextSignUpList[2],
                    errorStyle: const TextStyle(fontSize: 15),
                    labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
                    suffixStyle: const TextStyle(fontSize: 15, color: Colors.white),
                    hintStyle: const TextStyle(fontSize: 15, color: Colors.white),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  )))),
      Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
              onHover: (ishover) {
                if (ishover) {
                  isLoginHover = false;
                } else {
                  isLoginHover = true;
                }
                setState(() {});
              },
              onTap: () {
                returnErrString(userProvider, homePageProvider);
              },
              child: Container(
                  width: 250,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isLoginHover ? Colors.blueAccent : Colors.green, borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: logInCircle
                      ? const Text('회원가입', style: TextStyle(color: Colors.white))
                      : const CircularProgressIndicator(backgroundColor: Colors.white)))),
    ]);
  }


  void returnErrString(UserProvider userProvider, HomePageProvider homePageProvider) {
    print('errstring messgae pass');
    String resultId = '';
    String resultPass = '';
    String resultPassCheck = '';
    bool isko = false;
    if(textEditingSignUpControllerList[0].text.isNotEmpty){
      isko = isKorean(textEditingSignUpControllerList[0].text);
    }

    if (textEditingSignUpControllerList[0].text.isEmpty) {
      resultId = '아디디를 적어주세요';
      focusNodeSignUpList[0].requestFocus();
    } else if (textEditingSignUpControllerList[0].text.length < 4) {
      resultId = '4자리 이상 적어주세요';
      focusNodeSignUpList[0].requestFocus();
    } else if (isko) {
      print('??????????');
      resultId = '영문 숫자 특수문자 조합으로 부탁드려요';
      focusNodeSignUpList[0].requestFocus();
    } else if (textEditingSignUpControllerList[1].text.isEmpty) {
      resultPass = '비밀번호를 적어주세요';
      focusNodeSignUpList[1].requestFocus();
    } else if (textEditingSignUpControllerList[1].text.length < 4) {
      resultPass = '4자리 이상 적어주세요';
      focusNodeSignUpList[1].requestFocus();
    } else if (textEditingSignUpControllerList[2].text.isEmpty) {
      resultPassCheck = '비밀번호를 확인해주세요';
      focusNodeSignUpList[2].requestFocus();
    } else if (textEditingSignUpControllerList[2].text.length < 4) {
      resultPassCheck = '4자리 이상 적어주세요';
      focusNodeSignUpList[2].requestFocus();
    } else if (textEditingSignUpControllerList[1].text != textEditingSignUpControllerList[2].text) {
      resultPassCheck = '비밀번호가 동일하지 않습니다.';
      focusNodeSignUpList[2].requestFocus();
      //중복체크
    } else if (doubleCheck) {
      print('double check true');
      //서버연동
      UserControl.signUp(textEditingSignUpControllerList[0].text, textEditingSignUpControllerList[1].text).then((value){
        print('server pass################ $value');
        if(value){
          userProvider.setUserId(textEditingSignUpControllerList[0].text);
          homePageProvider.pageChange(0);
        }else{
          resultPassCheck = 'err';
        }
      });
      print('pass');
    }else{
      print('double check false');
      resultId = '사용중인 아이디 입니다.';
      textEditingSignUpControllerList[0].clear();
      idErrColor = false;
      focusNodeSignUpList[0].requestFocus();
    }

    setState(() {
      errTextSignUpList[0] = resultId;
      errTextSignUpList[1] = resultPass;
      errTextSignUpList[2] = resultPassCheck;
    });
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
