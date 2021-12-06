import 'dart:convert';
import "dart:convert" show utf8;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';

// ignore_for_file: avoid_print
class NodeServer {

  static Future<bool> googleAccessSignIn(String email, String name, String id) async {
    print('nodeserver google access signin pass');
    bool returnBool = false;
    String flag = 'googleAccessSignIn';
    String siteKey = 'secretKey';
    String url = MyWord.serverIpAndPort + '/user';
    Map<String, String> map = {};
    map = {"siteKey": siteKey, "email": email, "name": name, "googleAccessId": id, "flag": flag};

    try {
      Response response = await http.post(Uri.parse(url), headers: map);
      print(response.body);
      int stateCode = response.statusCode;
      if (stateCode == 200) {
        var result = jsonDecode(response.body);
        String approved = result.values.elementAt(0);
        print(approved);
        if (approved == 'pass') {
          returnBool = true;
        }
      }
    } catch (e) {
      print('signIn err : $e');
    }

    return returnBool;
  }

  static Future<bool> setContents({required String title, required List<XFile> images, required UserProvider userProvider}) async {
    print('set content pass ${userProvider.userId}');
    Map<String, String> map = {};
    String flag = 'setContents';
    String siteKey = 'secretKey';
    String url = MyWord.serverIpAndPort + '/setcontents';
    map = {
      "sitekey": siteKey,
      "flag": flag,
      "userid": userProvider.userId,
      "usergoogleaccessid": userProvider.googleAccessId,
    };
    bool returnResult = false;

    Uri uri = Uri.parse(url);
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
      var contentEncode = utf8.encode(title);
      request.fields['content'] = '$contentEncode';
      request.headers.addAll(map);
      print('//////////////////////////////////');
      print(request.toString());
      try {
        StreamedResponse response = await request.send();
        int state = response.statusCode;
        print(response.statusCode);
        if (state == 200) {
          String respStr = await response.stream.bytesToString();
          Map<dynamic, dynamic> responsePassCheck = jsonDecode(respStr);
          if (responsePassCheck.values.elementAt(0) == 'pass') {
            returnResult = true;
          } else {
            returnResult = false;
          }
        } else if (state == 500) {}
      } catch (e) {
        print('err $e');
      }
    }
    return returnResult;
  }

  static Future<List<dynamic>> getUserContent(int getContentCountPlus, String userId) async {
    List<dynamic> returnList = [];
    print('npde serverr getusercontents pass');
    String flag = 'getusercontents';
    String url = MyWord.serverIpAndPort + '/getusercontents';
    String siteKey = 'secretKey';
    Map<String, String> map = {};
    map = {"sitekey": siteKey, "flag": flag, "getcontentcountplus": '$getContentCountPlus', "userid": userId};

    try {
      var response = await http.post(Uri.parse(url), headers: map);
      int state = response.statusCode;
      print(response.statusCode);
      if (state == 200) {
        Map result = jsonDecode(response.body);
        //print(result);
        String approved = result.values.elementAt(0);
        List message = result.values.elementAt(1);
        print('=============================');
        print(approved);
        if (approved == 'pass') {
          for (Map<dynamic, dynamic> element1 in message) {
            ContentDataModel contentDataModel = ContentDataModel.fromJson(element1);
            returnList.add(contentDataModel);
          }
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
static Future<bool> deleteContent(int contentId, String userId) async {
  String flag = 'deleteContent';
  String siteKey = 'secretKey';
  String url = MyWord.serverIpAndPort + '/deletecontent';
  bool returnResult = false;
  Map<String, String> map = {};
  map = {"siteKey": siteKey, "flag": flag, "contentid": '$contentId', "id": userId};
  try {
    var response = await http.post(Uri.parse(url), headers: map);
    int stateCode = response.statusCode;
    print('$stateCode pass');
    if (stateCode == 200) {
      Map responseValue = jsonDecode(response.body);
      if (responseValue.values.first.contains('pass')) {
        returnResult = true;
      } else if (responseValue.values.first.contains('no')) {
        returnResult = false;
      }
    }
  } catch (e) {
    print('setComment error :$e');
    returnResult = false;
  }

  return returnResult;
}

static Future<bool> deleteAllContent(String userId) async {
  String flag = 'deleteAllContent';
  String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
  String url = MyWord.serverIpAndPort + '/deleteallcontent';
  bool returnResult = false;
  Map<String, String> map = {};
  map = {"siteKey": siteKey, "flag": flag, "id": userId};
  try {
    var response = await http.post(Uri.parse(url), headers: map);
    int stateCode = response.statusCode;
    print('$stateCode pass');
    if (stateCode == 200) {
      Map responseValue = jsonDecode(response.body);

      if (responseValue.values.first.contains('pass')) {
        returnResult = true;
      } else if (responseValue.values.first.contains('no')) {
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
    String url = MyWord.serverIpAndPort + '/setcomment';
    bool returnResult = false;
    Map<String, String> map = {};

    var contentEncode = utf8.encode(value);
    map = {"siteKey": siteKey, "id": userId, "comment": '$contentEncode', "flag": flag, "contentseq": '$index'};
    try {
      var response = await http.post(Uri.parse(url), headers: map);
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
    String url = MyWord.serverIpAndPort + '/likeandbad';
    Map<String, String> map = {};
    //print('???? $likeAndBadCount');
    map = {"siteKey": siteKey, "flag": flag, "likeandbadflag": '$likeAndBadFlag', "likeandbadcount": '$likeAndBadCount', "contentid": '$contentId'};

    try {
      var response = await http.post(Uri.parse(url), headers: map);
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
  static Future<int> signIn(String id, String pass) async {
    int returnInt = 0;
    String flag = 'signIn';
    String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
    String url = MyWord.serverIpAndPort + '/user';
    Map<String, String> map = {};
    map = {"siteKey": siteKey, "id": id, "pass": pass, "flag": flag};
    try {
      http.Response response = await http.post(Uri.parse(url), headers: map);
      int stateCode = response.statusCode;
      if (stateCode == 200) {
        Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
        print(responsePassCheck);
        if (responsePassCheck.values.elementAt(0) == 'pass') {
          if (responsePassCheck.values.elementAt(1) == true) {
            //아이디와 비번이 맞음 통과
            returnInt = 1;
            print('Pass!!!!!!!');
          } else {
            //아이디 중복 안됨
            returnInt = 2; //서버와 통신은 잘됨 아이디와 비밀번호가 다름!!
            print('노노!!!!!!!');
          }
        } else if (responsePassCheck.values.elementAt(0) == 'FE') {
          returnInt = 0; //서버에러
          print('FE!!!!!!!');
        } else if (responsePassCheck.values.elementAt(0) == 'SK') {
          returnInt = 0; //서버에러
          print('SK!!!!!!!');
        }
      } else {
        returnInt = 0; // 200 아님
      }
    } catch (e) {
      print('signIn err : $e');
      returnInt = 0; // 서버 통신 장애
    }
    return returnInt;
  }

//
  static Future<int> doubleCheck(String id) async {
    int result = 0;
    String flag = 'doublecheck';
    String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
    String url = MyWord.serverIpAndPort + '/user';
    Map<String, String> requestMap = {};

    requestMap = {"siteKey": siteKey, "id": id, "flag": flag};
    try {
      var response = await http.post(Uri.parse(url), headers: requestMap);
      int stateCode = response.statusCode;
      if (stateCode == 200) {
        Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
        print(responsePassCheck);
        if (responsePassCheck.values.elementAt(0) == 'pass') {
          if (responsePassCheck.values.elementAt(1) == 'true') {
            //아이디가 중복된다는 것임
            result = 2; //서버와 통신은 잘되는데 아이디만 중복됨
          } else {
            //아이디 중복 안됨
            result = 1; //서버와 통신은 잘되고 아이디도 중복 안됨
          }
        } else {
          result = 0; //서버에러
        }
      } else {
        result = 0; //서버에러
      }
    } catch (e) {
      print('signup err : $e');
      result = 0; //서버에러
    }
    return result;
  }

  static Future<bool> signUp(String id, String pass) async {
    bool result = false;
    String flag = 'signup';
    String siteKey = 'secretKey'; //실제 쓰일댄 이렇게 쓰면안됨 파이버 베이스 같은곳에 넣어서 쓰기
    String url = MyWord.serverIpAndPort + '/user';
    Map<String, String> requestMap = {};
    requestMap = {"siteKey": siteKey, "id": id, "pass": pass, "flag": flag};

    try {
      var response = await http.post(Uri.parse(url), headers: requestMap);
      int stateCode = response.statusCode;
      if (stateCode == 200) {
        Map<dynamic, dynamic> responsePassCheck = jsonDecode(response.body);
        print(responsePassCheck);
        if (responsePassCheck.values.elementAt(0) == 'pass') {
          result = true;
        } else {
          result = false; //서버에러
        }
      }
    } catch (e) {
      print('signup err : $e');
    }
    return result;
  }
}
