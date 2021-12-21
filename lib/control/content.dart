import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/server/nodeserver.dart';

// ignore_for_file: avoid_print
class ContentControl {

  static void navigatorPush(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static String redefine(ContentProvider contentProvider, ContentDataModel contentData) {
    String returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
    String imgString = '';
    List profileImageList = contentProvider.profileImageList;
    for (var element in profileImageList) {
      String userid5 = element['userId'];
      if (contentData.userId == userid5) {
        Map map = element['images'];
        imgString = map.values.elementAt(5).toString();
        returnProfileString = MyWord.imagesServerIpAndPort + imgString;
        break;
      } else {
        returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
      }
    }
    return returnProfileString;
  }

  static String redefineUserProfileImage(ContentProvider contentProvider, String userId) {
    String returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
    String imgString = '';
    List profileImageList = contentProvider.profileImageList;
    for (var element in profileImageList) {
      String userid5 = element['userId'];
      if (userId == userid5) {
        Map map = element['images'];
        imgString = map.values.elementAt(5).toString();
        returnProfileString = MyWord.imagesServerIpAndPort + imgString;
        break;
      } else {
        returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
      }
    }
    return returnProfileString;
  }

  static String redefineComment(ContentProvider contentProvider, CommentDataModel commentDataModel) {
    String returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
    String imgString = '';
    List profileImageList = contentProvider.profileImageList;
    for (var element in profileImageList) {
      String userid5 = element['userId'];
      if (commentDataModel.userId == userid5) {
        Map map = element['images'];
        imgString = map.values.elementAt(5).toString();
        returnProfileString = MyWord.imagesServerIpAndPort + imgString;
        break;
      } else {
        returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
      }
    }
    return returnProfileString;
  }

  static String redefineUserComment(UserContentProvider userContentProvider, CommentDataModel commentDataModel) {
    String returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
    String imgString = '';
    List profileImageList = userContentProvider.profileImage;
    for (var element in profileImageList) {
      String userid5 = element['userId'];
      if (commentDataModel.userId == userid5) {
        Map map = element['images'];
        imgString = map.values.elementAt(5).toString();
        returnProfileString = MyWord.imagesServerIpAndPort + imgString;
        break;
      } else {
        returnProfileString = MyWord.imagesServerIpAndPort + 'basic.png';
      }
    }
    print('-*---------------------');
    print(returnProfileString);
    return returnProfileString;
  }


  static Future<String> setLikeAndBad({required int flag, required int contentId, required int likeAndBad}) async {
    String result = '';
    bool ss = await NodeServer.setLikeAndBad(contentId: contentId, likeAndBadFlag: flag, likeAndBadCount: likeAndBad);
    if (ss) {
      result = 'ok';
    } else {
      result = 'no';
    }
    return result;
  }

  static String contentTimeStamp(String date) {
    String resultTime = '';
    int databaseTimeStampInt = int.parse(date);
    var toDay = DateTime.now();
    int difDay = toDay.difference(DateTime.fromMillisecondsSinceEpoch(databaseTimeStampInt)).inDays;
    int difHour = toDay.difference(DateTime.fromMillisecondsSinceEpoch(databaseTimeStampInt)).inHours;
    int difMin = toDay.difference(DateTime.fromMillisecondsSinceEpoch(databaseTimeStampInt)).inMinutes;
    String agoYear = '년전';
    String agoMonth = '달전';
    String agoDay = '일전';
    String agoHours = '시간전';
    String agoMinute = '분전';

    if (difMin <= 60 && difMin >= 0) {
      //print('0~60분 사이');
      resultTime = difMin.toString() + agoMinute;
    } else if (difMin > 60 && difMin <= 1440) {
      //24시간 해결
      //print('1~24시간 사이');
      resultTime = difHour.toString() + agoHours;
    } else if (difDay >= 1 && difDay <= 30) {
      //24시간 이후 1일
      //print('1~30일 사이');
      resultTime = difDay.toString() + agoDay;
    } else if (difDay > 30 && difDay <= 365) {
      //print('1~12딜 사이');
      double monthD = difDay / 30;
      int monthInt = monthD.floor();
      resultTime = monthInt.toString() + agoMonth;
    } else if (difDay > 365) {
      // 1년
      // print('1년 이상 ');
      double year = difDay / 365;
      int yearInt = year.floor();
      resultTime = yearInt.toString() + agoYear;
    } else {}
    return resultTime;
  }

  static Future<Map> setContent({required String title, required List<XFile> images, required UserProvider userProvider}) async {
    print('setcontent control pass');
    Map resultMap = {};
    bool result = false;
    if (title == '' || title.isEmpty) {
      resultMap = {'title': '타이틀', 'message': '타이틀을 적어주세요'};
    } else if (images.isEmpty) {
      resultMap = {'title': '사진이 없어요', 'message': '사진을 추가해 주세요'};
    } else {
      await NodeServer.setContents(images: images, userProvider: userProvider, title: title).then((value) => {result = value});
      if (result) {
        resultMap = {'title': 'pass', 'message': ''};
      } else {
        resultMap = {'title': '에러', 'message': '관리자에게 문의 하세요'};
      }
    }
    return resultMap;
  }
}
