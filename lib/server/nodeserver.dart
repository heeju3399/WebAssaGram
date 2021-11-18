import 'dart:convert';
import "dart:convert" show utf8;

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/model/content.dart';

import 'package:web/model/myword.dart';

// ignore_for_file: avoid_print
class NodeServer {
  // postFile(List<XFile> files) async {
  //
  //   FormData formData = FormData.fromMap({
  //     "attachments": files,
  //   });
  //   var dio = Dio();
  //
  //   try {
  //     var response = await dio.post(
  //       MyWord.localhostContentServerIp,
  //       data: formData, queryParameters: {'sitekey':'abs','s':'f'},
  //
  //     );
  //
  //     print("응답" + response.data.toString());
  //   } catch (eee) {
  //     print(eee);
  //     print("error occur");
  //   }
  // }

  static Future<bool> setContents({required String title, required List<XFile> images, required String userId}) async {
    print('set content pass');
    Map<String, String> map = {};
    String flag = 'setContents';
    String siteKey = 'secretKey';
    map = {"sitekey": siteKey, "flag": flag, "userid": userId};
    bool returnResult = false;
    String url = 'http://172.30.1.19:3000';
    Uri uri = Uri.parse(url + '/setcontents');
    MultipartRequest request = http.MultipartRequest("POST", uri);
    if (images.isNotEmpty) {
      for (var file in images) {
        print('for pass');
        String mimeType = file.mimeType!;
        List mimeList = mimeType.split('/');
        String type = mimeList[0];
        String subType = mimeList[1];
        List<int> imageData = await file.readAsBytes();
        MultipartFile multipartFile = MultipartFile.fromBytes(
          'photo',
          imageData,
          filename: file.name,
          contentType: MediaType(type, subType),
        );
        request.files.add(multipartFile);
      }
      request.fields['content'] = title;
      request.headers.addAll(map);
      print('//////////////////////////////////');
      print(request.toString());
      try {
        StreamedResponse response = await request.send();
        int state = response.statusCode;
        print(response.statusCode);
        if (state == 200) {
          String respStr = await response.stream.bytesToString();
          print('0000000000000000000000000000');
          print(respStr);
          print(response.statusCode);
          print(response.headers);
          respStr = respStr.substring(10, 14);
          if (respStr.contains('pass')) {
            returnResult = true;
          } else if (respStr.contains('no')) {
            returnResult = false;
          }
        } else if (state == 500) {}
      } catch (e) {
        print('err $e');
      }
    }
    return returnResult;
  }

  static Future<List<dynamic>> getContent(int getContentCountPlus) async {
    List<dynamic> returnList = [];
    print('getContent pass');
    String flag = 'getContents';
    String siteKey = 'secretKey';
    Map<String, String> map = {};
    map = {"sitekey": siteKey, "flag": flag, "getcontentcountplus": '$getContentCountPlus'};
    Uri uri = Uri.parse('http://172.30.1.19:3000/getcontents');
    try {
      var response = await http.post(uri, headers: map);
      int state = response.statusCode;
      print(response.statusCode);
      if (state == 200) {
        Map result = jsonDecode(response.body);
        //print(result);
        String approved = result.values.elementAt(0);
        List message = result.values.elementAt(1);
        print('=============================');
        //print(approved);
        if (approved == 'pass') {
          for (Map<dynamic, dynamic> element1 in message) {
            ContentDataModel contentDataModel = ContentDataModel.fromJson(element1);
            returnList.add(contentDataModel);
          }
          // for (ContentDataModel contentdata in returnList) {
          //   for (var element in contentdata.images) {
          //     ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(element);
          //     print(imagesDataModel.path);
          //   }
          //   for (var element in contentdata.comment) {
          //     CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
          //     print(commentDataModel.createTime);
          //     print('=============================');
          //   }
          // }
        } else {
          returnList.add('not pass');
        }
      } else {
        returnList.add('state err');
      }
    } catch (e) {
      returnList.add('server connect fail');
    }
    return returnList;
  }

// static Future<bool> userDelete({String userId}) async {
//   String flag = 'userDelete';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   bool returnResult = false;
//   Map<String, String> map = {};
//   map = {"siteKey": siteKey, "flag": flag, "id": userId};
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}userdelete'), headers: map);
//     int stateCode = response.statusCode;
//     if (stateCode == 200) {
//       Map responseValue = jsonDecode(response.body);
//       if (responseValue.values.first.contains('pass')) {
//         returnResult = true;
//       } else if (responseValue.values.first.contains('no')) {
//         returnResult = false;
//       }
//     }
//   } catch (e) {
//     print('deleteComment error :$e');
//     returnResult = false;
//   }
//   return returnResult;
// }
//
// static Future<bool> deleteComment({ int contentId,  String userId,  int order}) async {
//   String flag = 'deleteComment';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   bool returnResult = false;
//   Map<String, String> map = {};
//   map = {"siteKey": siteKey, "flag": flag, "contentid": '$contentId', "id": userId, "order": '$order'};
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}deletecomment'), headers: map);
//     int stateCode = response.statusCode;
//     print('$stateCode pass');
//     if (stateCode == 200) {
//       Map responseValue = jsonDecode(response.body);
//       if (responseValue.values.first.contains('pass')) {
//         returnResult = true;
//       } else if (responseValue.values.first.contains('no')) {
//         returnResult = false;
//       }
//     }
//   } catch (e) {
//     print('deleteComment error :$e');
//     returnResult = false;
//   }
//   return returnResult;
// }
//
// static Future<bool> deleteContent(int contentId, String userId) async {
//   String flag = 'deleteContent';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   bool returnResult = false;
//   Map<String, String> map = {};
//   map = {"siteKey": siteKey, "flag": flag, "contentid": '$contentId', "id": userId};
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}deletecontent'), headers: map);
//     int stateCode = response.statusCode;
//     print('$stateCode pass');
//     if (stateCode == 200) {
//       Map responseValue = jsonDecode(response.body);
//
//       if (responseValue.values.first.contains('pass')) {
//         returnResult = true;
//       } else if (responseValue.values.first.contains('no')) {
//         returnResult = false;
//       }
//     }
//   } catch (e) {
//     print('setComment error :$e');
//     returnResult = false;
//   }
//
//   return returnResult;
// }
//
// static Future<bool> deleteAllContent(int contentId, String userId) async {
//   String flag = 'deleteAllContent';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   bool returnResult = false;
//   Map<String, String> map = {};
//   map = {"siteKey": siteKey, "flag": flag, "contentid": '$contentId', "id": userId};
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}deleteallcontent'), headers: map);
//     int stateCode = response.statusCode;
//     print('$stateCode pass');
//     if (stateCode == 200) {
//       Map responseValue = jsonDecode(response.body);
//
//       if (responseValue.values.first.contains('pass')) {
//         returnResult = true;
//       } else if (responseValue.values.first.contains('no')) {
//         returnResult = false;
//       }
//     }
//   } catch (e) {
//     print('setComment error :$e');
//     returnResult = false;
//   }
//
//   return returnResult;
// }
//
// static Future<List<dynamic>> getUserContents({ String userId}) async {
//   String flag = 'getusercontent';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   Map<String, String> map = Map();
//   List returnList = [];
//   map = {"siteKey": '$siteKey', "flag": '$flag', "id": '$userId'};
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}getusercontent'), headers: map);
//     int stateCode = response.statusCode;
//     print('$stateCode pass');
//     if (stateCode == 200) {
//       Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
//       if (responsePassCheck.values.elementAt(0).contains('pass')) {
//         returnList.add('pass');
//         String mainDashContent = responsePassCheck.values.elementAt(1).toString();
//         returnList.add(jsonDecode(mainDashContent));
//       }
//     } else {
//       returnList.add('no');
//     }
//   } catch (e) {
//     print('getUserContents err : $e');
//     returnList.add('err');
//   }
//
//   return returnList;
// }
//
  static Future<bool> setComment({required String value, required int index, required String userId}) async {
    String flag = 'setcomment';
    String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
    bool returnResult = false;
    Map<String, String> map = {};

    var contentEncode = utf8.encode(value);
    map = {"siteKey": siteKey, "id": userId, "comment": '$contentEncode', "flag": flag, "contentseq": '$index'};
    try {
      var response = await http.post(Uri.parse(MyWord.localhostSetCommentServerIp), headers: map);
      int stateCode = response.statusCode;
      print('$stateCode pass');
      if (stateCode == 200) {
        Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
        if (responsePassCheck.values.elementAt(0) == 'pass') {
          returnResult = true;
        } else {
          returnResult = false;
        }
      }
    } catch (e) {
      print('setComment error :$e');
      returnResult = false;
    }
    return returnResult;
  }

//
  static Future<bool> setLikeAndBad({required int contentId, required int likeAndBadFlag, required int likeAndBadCount}) async {
    String flag = 'setlikeandbad';
    String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
    bool returnResult = false;
    Map<String, String> map = {};
    //print('???? $likeAndBadCount');
    map = {"siteKey": siteKey, "flag": flag, "likeandbadflag": '$likeAndBadFlag', "likeandbadcount": '$likeAndBadCount', "contentid": '$contentId'};

    try {
      var response = await http.post(Uri.parse(MyWord.localhostLikeAndBadServerIp), headers: map);
      int stateCode = response.statusCode;
      if (stateCode == 200) {

        Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
        if (responsePassCheck.values.elementAt(0) == 'pass') {
          returnResult = true;
        } else {
          returnResult = false;
        }
      }
    } catch (e) {
      print(e);
      returnResult = false;
    }
    return returnResult;
  }
//
// void getLikeAndBad() async {}

// static Future<List<dynamic>> getAllContents() async {
//   String flag = 'setcontent';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   Map<String, String> map = Map();
//   List returnList = [];
//   map = {"siteKey": '$siteKey', "flag": '$flag'};
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}getallcontent'), headers: map);
//     int stateCode = response.statusCode;
//     print('$stateCode pass');
//     if (stateCode == 200) {
//       Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
//       if (responsePassCheck.values.elementAt(0).contains('pass')) {
//         print('pass _ pass');
//         returnList.add('pass');
//         List<dynamic> mainDashContent = responsePassCheck.values.elementAt(1);
//         returnList.add(mainDashContent);
//       }
//     } else {
//       returnList.add('no');
//     }
//   } catch (e) {
//     print('getAllContents err : $e');
//     returnList.add('err');
//   }
//   return returnList;
// }
//
// static Future<LogInResponse> signIn(String id, String pass) async {
//   String flag = 'signIn';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   var response;
//   LogInResponse logInResult = LogInResponse(stateCode: 000, message: '서버 접속 불가', title: 'err');
//   Map<String, String> map = Map();
//   map = {"siteKey": '$siteKey', "id": '$id', "pass": '$pass', "flag": '$flag'};
//   try {
//     response = await http.post(Uri.parse('${MyWord.ipAndPort}login'), headers: map);
//     int stateCode = response.statusCode;
//     Map stateMap = Map();
//     Map<dynamic, dynamic> returnMap = Map();
//     var decode = jsonDecode(response.body);
//     returnMap.addAll(decode);
//     stateMap = {'stateCode': stateCode};
//     returnMap.addAll(stateMap);
//     logInResult = LogInResponse.fromJson(returnMap);
//   } catch (e) {
//     print('signIn err : $e');
//   }
//   return logInResult;
// }
//
// static Future<SignupResponse> signUp({ String id,  String pass,  String name}) async {
//   String flag = 'signup';
//   String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
//   Map<String, String> requestMap = Map();
//   requestMap = {"siteKey": '$siteKey', "id": '$id', "pass": '$pass', "name": '$name', "flag": '$flag'};
//   SignupResponse signUpResponse = SignupResponse(stateCode: 000, message: '서버 접속 불가', title: 'err');
//   try {
//     var response = await http.post(Uri.parse('${MyWord.ipAndPort}signup'), headers: requestMap);
//     int stateCode = response.statusCode;
//     Map returnMap = Map();
//     Map<dynamic, dynamic> stateMap = Map();
//     var decode = jsonDecode(response.body);
//     stateMap.addAll(decode);
//     returnMap = {'stateCode': stateCode};
//     stateMap.addAll(returnMap);
//     signUpResponse = SignupResponse.fromJson(stateMap);
//   } catch (e) {
//     print('signup err : $e');
//   }
//   return signUpResponse;
// }
}
