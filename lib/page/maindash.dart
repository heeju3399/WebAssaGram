import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/model/darktheme.dart';
import 'package:web/model/icons.dart';
import 'package:web/model/mywidget.dart';
import 'package:web/model/myword.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/shared.dart';
import 'package:web/page/user/favoritepage.dart';
import 'package:web/page/user/profilepage.dart';
import 'package:web/responsive.dart';
import 'addpage.dart';
import 'homepage.dart';
import 'user/signmain.dart';

class MainDash extends StatefulWidget {
  const MainDash({Key? key}) : super(key: key);

  @override
  _MainDashState createState() => _MainDashState();
}

// ignore_for_file: avoid_print
class _MainDashState extends State<MainDash> with SingleTickerProviderStateMixin {
  DateTime currentBackPressTime = DateTime.now();
  final ScrollController _scrollController1 = ScrollController();
  List<FocusNode> myFocusNodeList = [];
  int listViewCount = 5;

  @override
  void dispose() {
    print('main dash dispose pass');
    for (var element in myFocusNodeList) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePageProvider homepageProvider = Provider.of<HomePageProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    print('build pass');
    String userId = userProvider.userId;

    print('main Dash call userid : $userId');
    return WillPopScope(
        onWillPop: onWillPop,
        child: Responsive.isLarge(context) ? windowPage(context, userId, homepageProvider, userProvider) : mobilePage(context, userId));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Fluttertoast.showToast(msg: '종료 하시려면 한번더 터치해주세요');aaasdfasdf yhnujiklo89v
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget mobilePage(BuildContext context, String userId) {
    bool checkLogin = false;
    print('???? : $userId');
    if (userId == MyWord.LOGIN) {
      checkLogin = true;
    }
    print('?? : $checkLogin');
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Mobile!'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////
  Widget mainContent(BuildContext context, String userId, HomePageProvider homePageProvider) {
    Widget result = const CircularProgressIndicator();
    if (homePageProvider.pageFlag == 0) {
      result = const HomePage();
    } else if (homePageProvider.pageFlag == 1) {
      listViewCount = 5;
      result = const AddPage();
    } else if (homePageProvider.pageFlag == 2) {
      //result = favoritePage(context, userId);
      result = const FavoritePage();
    } else if (homePageProvider.pageFlag == 3) {
      result = const ProfilePage();
    } else if (homePageProvider.pageFlag == 4) {
      result = const LogInMainPage();
    }
    return result;
  }

  Widget windowPage(BuildContext context, String userId, HomePageProvider homePageProvider, UserProvider userProvider) {
    return Scaffold(
      backgroundColor: DisplayControl.mainAppColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        primary: true,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text('ASSA_GRAM', style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
        actions: [
          const SizedBox(width: 50),
          IconButton(
              onPressed: () => homePageProvider.pageChange(0),
              icon: homePageProvider.isMainIconsColor[0]
                  ? const Icon(Icons.home_filled, color: Colors.red)
                  : const Icon(Icons.home_outlined, color: Colors.black)),
          const SizedBox(width: 20),
          if (userId != 'logIn')
            IconButton(
                onPressed: () => homePageProvider.pageChange(1),
                icon: homePageProvider.isMainIconsColor[1]
                    ? const Icon(DIcons.add_circle, color: Colors.red)
                    : const Icon(DIcons.add_circle, color: Colors.black)),
          if (userId != 'logIn') const SizedBox(width: 20),
          if (userId != 'logIn')
            IconButton(
                onPressed: () => homePageProvider.pageChange(2),
                icon: homePageProvider.isMainIconsColor[2]
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border, color: Colors.black)),
          if (userId != 'logIn') const SizedBox(width: 20),
          //로그인했으면 프로필 버튼!
          if (userId != 'logIn')
            TextButton(
                onPressed: () => homePageProvider.pageChange(3),
                child: homePageProvider.isMainIconsColor[3]
                    ? Text(userId, maxLines: 1, overflow: TextOverflow.clip, style: const TextStyle(color: Colors.red, fontSize: 15))
                    : Text(userId, maxLines: 1, overflow: TextOverflow.clip, style: const TextStyle(color: Colors.black, fontSize: 15))),
          //안했으면 로그인 버튼!
          if (userId == 'logIn')
            IconButton(
                onPressed: () => homePageProvider.pageChange(4), //로그인 페이지로 이동하기
                icon: homePageProvider.isMainIconsColor[4]
                    ? const Icon(DIcons.sign_in, color: Colors.red)
                    : const Icon(DIcons.sign_in, color: Colors.black)),
          const SizedBox(width: 100),
          //tab bar!!
        ],
      ),
      body: SingleChildScrollView(
          controller: _scrollController1,
          physics: homePageProvider.save ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          //physics: const ScrollPhysics(),
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 30),
            SizedBox(width: 900, child: mainContent(context, userId, homePageProvider)),
            const SizedBox(height: 30),
            Container(height: 100, color: DisplayControl.mainAppColor, alignment: Alignment.center, child: MyWidget.myTextWhite('Test Corp'))
          ]))),
      floatingActionButton: homePageProvider.isFloating
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _scrollController1.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
                  },
                  child: const Icon(Ionicons.arrow_up),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    double downCount = homePageProvider.downCountPlus;
                    double low = 5000.0 * downCount;
                    _scrollController1.animateTo(low, duration: const Duration(milliseconds: 300), curve: Curves.linear);
                  },
                  child: const Icon(Ionicons.arrow_down),
                ),
              ],
            )
          : null,
    );
  }

  //
  // void _logInOperation(BuildContext context) async {
  //   if (overClick) {
  //     setState(() {
  //       logInCircle = !logInCircle;
  //     });
  //     overClick = false;
  //     await UserControl.logIn(textFiledIdController.text, textFiledPassController.text).then((map) {
  //       print('map : $map');
  //       if (map.isNotEmpty) {
  //         if (map.values.first == 'pass') {
  //           //String userid = textFiledIdController.text.toString();
  //           //MyShared myShared = MyShared();
  //           //myShared.setUserId(userid);
  //
  //           //Navigator.of(context).pop();
  //         } else {
  //           MyDialog.setContentDialog(title: map.values.first.toString(), message: map.values.last.toString(), context: context);
  //           textFiledPassController.clear();
  //         }
  //         setState(() {
  //           logInCircle = !logInCircle;
  //         });
  //       }
  //       overClick = true;
  //     });
  //   }
  // }
}
