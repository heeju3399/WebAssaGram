import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/page/dialog/dialog.dart';
import 'package:web/page/user/signinbuild.dart';
import 'package:web/page/user/signupbuild.dart';

import 'idsearchbuild.dart';

class LogInMainPage extends StatefulWidget {
  const LogInMainPage({Key? key}) : super(key: key);

  @override
  _LogInMainPageState createState() => _LogInMainPageState();
}

class _LogInMainPageState extends State<LogInMainPage> {

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    HomePageProvider homepageProvider = Provider.of<HomePageProvider>(context);
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Padding(padding: EdgeInsets.all(18.0), child: Text('ASSA_GRAM', textScaleFactor: 2, style: TextStyle(color: Colors.white))),
      //여기부터////여기부터////여기부터////여기부터//여기부터/
      if (homepageProvider.loginPageFlag == 0) const SignInBuild(),
      if (homepageProvider.loginPageFlag == 1) const SignUpBuild(),
      if (homepageProvider.loginPageFlag == 2) const SearchBuild(),
      //여기부터/부터//여기까지!!!!!!!!!!!!!!!!!!!!!!!!
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 120,
            height: 60,
            child: TextButton(
                onPressed: () {
                  print('로그인 pass');
                  homepageProvider.loginPageChanger(0);

                },
                child: const Text('로그인', style: TextStyle(fontSize: 14, color: Colors.white)))),
        Container(
            width: 120,
            height: 60,
            child: TextButton(
                onPressed: () {
                  print('up pass');
                  homepageProvider.loginPageChanger(1);

                },
                child: const Text('회원가입', style: TextStyle(fontSize: 14, color: Colors.white)))),
        Container(
            width: 120,
            height: 60,
            child: TextButton(
                onPressed: () {
                  print('search pass');
                  homepageProvider.loginPageChanger(2);
                },
                child: const Text('아이디/비번찾기', style: TextStyle(fontSize: 14, color: Colors.white)))),
      ]),
      const Divider(),

      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: Colors.blue,
              height: 50,
              width: 300,
              alignment: Alignment.center,
              child: InkWell(
                  onTap: () {
                    callGoogleApiAccess(userProvider, homepageProvider);
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Spacer(flex: 1),
                    Padding(padding: const EdgeInsets.all(8.0), child: Image.asset('./assets/images/google.png')),
                    const Spacer(flex: 5),
                    const Text('google로 로그인', style: TextStyle(color: Colors.white, fontSize: 15)),
                    const Spacer(flex: 5)
                  ])))),
    ]));
  }





  void callGoogleApiAccess(UserProvider userProvider, HomePageProvider homepageProvider) async {
    int result = await userProvider.googleLogin();
    if (result == 0) {
      //로그인이 안된것
    } else if (result == 1) {
      //pass
      homepageProvider.pageChange(0);
    } else if (result == 2) {
      //서버에서 팅긴것
      MyDialog.setContentDialog(title: '응답이 없습니다.', message: '관리자에게 문의 바랍니다.', context: context);
    }
  }


}
