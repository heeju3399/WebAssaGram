import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/userprovider.dart';

// ignore_for_file: avoid_print
class SignInBuild extends StatefulWidget {
  const SignInBuild({Key? key}) : super(key: key);

  @override
  _SignInBuildState createState() => _SignInBuildState();
}

class _SignInBuildState extends State<SignInBuild> {
  TextEditingController textFiledIdController = TextEditingController();
  TextEditingController textFiledPassController = TextEditingController();
  int count2 = 1;
  String errIdText = '';
  String errPassText = '';
  Color btnColor = Colors.blueAccent;
  bool logInCircle = true;
  bool overClick = true;
  bool isLoginHover = true;
  FocusNode focusNodeIdEdit = FocusNode();
  FocusNode focusNodePassEdit = FocusNode();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    HomePageProvider homePageProvider = Provider.of<HomePageProvider>(context);
    return signInPage(userProvider, homePageProvider);
  }

  Widget signInPage(UserProvider userProvider, HomePageProvider homePageProvider) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: textFiledIdController,
              focusNode: focusNodeIdEdit,
              autofocus: true,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'ID',
                  errorText: errIdText,
                  labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  suffixStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  hintStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  errorStyle: const TextStyle(fontSize: 15),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              onSubmitted: (v) {
                focusNodePassEdit.requestFocus();
              },
            ),
          )),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: 300,
              child: TextField(
                  focusNode: focusNodePassEdit,
                  controller: textFiledPassController,
                  onSubmitted: (v) {
                    returnErrString(userProvider, homePageProvider);
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'PASS',
                    errorText: errPassText,
                    errorStyle: const TextStyle(fontSize: 15),
                    labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    suffixStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    hintStyle: const TextStyle(fontSize: 20, color: Colors.white),
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
                      ? const Text('?????????', style: TextStyle(color: Colors.white))
                      : const CircularProgressIndicator(backgroundColor: Colors.white)))),
    ]);
  }

  void returnErrString(UserProvider userProvider, HomePageProvider homePageProvider) async {
    String resultId = '';
    String resultPass = '';

    if (textFiledIdController.text.isEmpty) {
      resultId = '???????????? ???????????????';
      focusNodeIdEdit.requestFocus();
    } else if (textFiledPassController.text.isEmpty) {
      resultPass = '??????????????? ???????????????';
      focusNodePassEdit.requestFocus();
    } else if (textFiledIdController.text.isNotEmpty && textFiledPassController.text.isNotEmpty) {
      bool idPass = isKorean(textFiledIdController.text);
      bool pswPass = isKorean(textFiledPassController.text);
      print('===$idPass // $pswPass ============= ');
      if (!idPass && !pswPass) {
        //server call
        int result = await userProvider.signIn(textFiledIdController.text, textFiledPassController.text);
        //int result = 2;
        if (result == 0) {
          //????????????
          resultPass = '????????? ???????????? ????????????.';
        } else if (result == 1) {
          //pass
          count2 = 0;
          userProvider.setUserId(textFiledIdController.text);
          homePageProvider.pageChange(0);
          // print('*****************************');
          // print(Navigator.of(context).canPop());

          if(Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          }

        } else if (result == 2) {
          //????????? ??????????????? ?????? ??????
          resultPass = '???????????? ??????????????? ?????????????????? \n???????????? ( $count2 ) ';
          textFiledPassController.clear();
          focusNodePassEdit.requestFocus();
          count2++;
        }
      } else {
        //?????? ?????????
        resultPass = '??????????????? ????????????????????????.';
        textFiledIdController.clear();
        textFiledPassController.clear();
        focusNodeIdEdit.requestFocus();
      }
    }

    setState(() {
      errIdText = resultId;
      errPassText = resultPass;
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
