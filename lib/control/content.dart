

import 'package:image_picker/image_picker.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/server/nodeserver.dart';

class ContentControl {

  static Future<String> setLikeAndBad({required int flag, required int contentId, required int likeAndBad}) async {
    String result = '';
    bool ss = await NodeServer.setLikeAndBad(contentId: contentId, likeAndBadFlag: flag, likeAndBadCount: likeAndBad );
    if(ss){
      result = 'ok';
    }else{
      result = 'no';
    }
    return result;
  }

  static String contentTimeStamp(String date){
    String resultTime = '';
    int databaseTimeStampInt = int.parse(date);
    var toDay = DateTime.now();
    //ring result = toDay.difference(DateTime.fromMillisecondsSinceEpoch(databaseTimeStampInt)).toString();
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
    } else {
      print('???????????????????');
    }
    //print('결과 : $resultTime');
    return resultTime;
  }

  static Future<Map> setContent({required String title,required List<XFile> images, required UserProvider userProvider}) async {
    print('setcontent control pass');
    Map resultMap = {};
    bool result = false;
    if (title == '' || title.isEmpty) {
      resultMap = {'title': '타이틀', 'message': '타이틀을 적어주세요'};
    } else if(images.isEmpty){
      resultMap = {'title': '사진이 없어요', 'message': '사진을 추가해 주세요'};
    } else {
      await NodeServer.setContents(images: images,userProvider: userProvider, title: title).then((value) => {result = value});
      if (result) {
        resultMap = {'title': 'pass', 'message': ''};
      } else {
        resultMap = {'title': '에러', 'message': '관리자에게 문의 하세요'};
      }
    }
    return resultMap;
  }
  //
  // static Future<List<MainContentDataModel>> getUserContents({required String userId}) async {
  //   List response = [];
  //   List<MainContentDataModel> returnList = [];
  //   await NodeServer.getUserContents(userId: userId).then((value) => {response = value});
  //   try {
  //     if (response.first == 'pass') {
  //       response = response.last;
  //       response.forEach((element) {
  //         MainContentDataModel mainContentDataModel = MainContentDataModel.fromJson(jsonDecode(jsonEncode(element)));
  //         returnList.add(mainContentDataModel);
  //       });
  //     }
  //   } catch (e) {
  //     print('getUserContent-err($e)');
  //   }
  //   return returnList;
  // }
  //
  // static Future<List<MainContentDataModel>> getContent2() async {
  //   List response = [];
  //   List<MainContentDataModel> returnList = [];
  //   await NodeServer.getAllContents().then((value) => {response = value});
  //   try {
  //     if (response.first == 'pass') {
  //       response = response.last;
  //       response.forEach((element) {
  //         MainContentDataModel mainContentDataModel = MainContentDataModel.fromJson(jsonDecode(jsonEncode(element)));
  //         returnList.add(mainContentDataModel);
  //       });
  //     }
  //   } catch (e) {
  //     print('getContent2 err ($e)');
  //   }
  //   //returnList = returnList.reversed.toList();
  //   return returnList;
  // }
  //
  static Future<bool> setComment({required String value, required int index,required String userId}) async {
    bool result = false;
    await NodeServer.setComment(userId: userId, index: index, value: value).then((value) => {result = value});
    print('????????????? $result');
    return result;
  }
  //
  // static void setLikeAndBad({required int flag, required int contentId}) {
  //   NodeServer.setLikeAndBad(contentId: contentId, likeAndBad: flag).then((value) => {});
  // }
  //
  // static void deleteContent(int contentId, String userId) {
  //   NodeServer.deleteContent(contentId, userId);
  // }
  //
  // static void deleteAllContent(int contentId, String userId) {
  //   NodeServer.deleteAllContent(contentId, userId);
  // }
  //
  // static void deleteComment({required int contentId, required String userId, required int order}) async {
  //   NodeServer.deleteComment(order: order, userId: userId, contentId: contentId); //bool 타입으로 리턴되는데 뭐쓰지?
  // }
  //
  // static void userDelete({required String userId}) async {
  //   bool check = false;
  //   await NodeServer.userDelete(userId: userId).then((value) => {
  //     check = value
  //   });
  //   if(check){
  //     MyShared.setUserId('LogIn');
  //     html.window.location.reload();
  //   }else{
  //
  //   }
  // }
}