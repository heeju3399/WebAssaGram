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

  static Future<List> getTenRankerProfileAndContent(int getRankerContentCountPlus) async {
    List<dynamic> returnList = [];

    print('getContent pass');
    String flag = 'getTenRankerContents';
    String siteKey = 'secretKey';
    String url = MyWord.serverIpAndPort + '/gettenrankercontents';
    Map<String, String> map = {};
    map = {"sitekey": siteKey, "flag": flag, "skipindex": '$getRankerContentCountPlus'};
    Uri uri = Uri.parse(url);
    try {
      var response = await http.post(uri, headers: map);
      int state = response.statusCode;
      print(response.statusCode);
      if (state == 200) {
        Map result = jsonDecode(response.body);
        print(result);
        String approved = result.values.elementAt(0);
        List message = result.values.elementAt(1);
        List imgProfile = result.values.elementAt(2);
        print('=============================');
        print(approved);
        if (approved == 'pass') {
          returnList.add(message);
          returnList.add(imgProfile);
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

  static Future<List> getRankerProfileAndContentInit(int getRankerContentCountPlus) async {
    List<dynamic> returnList = [];

    print('getContent pass');
    String flag = 'getRankerContents';
    String siteKey = 'secretKey';
    String url = MyWord.serverIpAndPort + '/getrankercontents';
    Map<String, String> map = {};
    map = {"sitekey": siteKey, "flag": flag, "getrankercontentcountplus": '$getRankerContentCountPlus'};
    Uri uri = Uri.parse(url);
    try {
      var response = await http.post(uri, headers: map);
      int state = response.statusCode;
      print(response.statusCode);
      if (state == 200) {
        Map result = jsonDecode(response.body);
        //print(result);
        String approved = result.values.elementAt(0);
        List message = result.values.elementAt(1);
        List imgProfile = result.values.elementAt(2);
        print('=============================');
        //print(approved);
        if (approved == 'pass') {
          returnList.add(message);
          // for (Map<dynamic, dynamic> element1 in message) {
          //   ContentDataModel contentDataModel = ContentDataModel.fromJson(element1);
          //   returnList.add(contentDataModel);
          // }
          returnList.add(imgProfile);
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


  static Future<bool> deleteProfileImage(String userId, String googleAccessId) async {
    String flag = 'deleteProfile';
    String siteKey = 'secretKey';
    String url = MyWord.serverIpAndPort + '/deleteprofile';
    bool returnResult = false;
    Map<String, String> map = {};
    String id = '';
    if (userId == '') {
      id = googleAccessId;
    } else {
      id = userId;
    }
    map = {"siteKey": siteKey, "flag": flag, "id": id};
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
      print('deleteProfile error :$e');
      returnResult = false;
    }
    return returnResult;

  }

  static Future<List> setProfileImage(String userId, String googleAccessId, XFile image) async {
    List returnBool = [];

    Map<String, String> map = {};
    String flag = 'setpimg';
    String siteKey = 'secretKey';
    String url = MyWord.serverIpAndPort + '/setprofileimage';
    Uri uri = Uri.parse(url);
    MultipartRequest request = http.MultipartRequest("POST", uri);
    print('for pass');
    String mimeType = image.mimeType!;
    List mimeList = mimeType.split('/');
    String type = mimeList[0];
    String subType = mimeList[1];
    List<int> imageData = await image.readAsBytes();
    MultipartFile multipartFile = MultipartFile.fromBytes(
      'photo',
      imageData,
      filename: image.name,
      contentType: MediaType(type, subType),
    );
    request.files.add(multipartFile);
    map = {
      "sitekey": siteKey,
      "flag": flag,
      "userid": userId,
      "usergoogleaccessid": googleAccessId,
    };
    request.headers.addAll(map);
    print('//////////////////////////////////');
    try {
      StreamedResponse response = await request.send();
      int state = response.statusCode;
      print(response.statusCode);
      if (state == 200) {
        String respStr = await response.stream.bytesToString();
        Map<dynamic, dynamic> responsePassCheck = jsonDecode(respStr);
        if (responsePassCheck.values.elementAt(0) == 'pass') {
          var pp = responsePassCheck.values.elementAt(1);
          returnBool.add('true');
          returnBool.add(pp);
        } else {
          returnBool.add('false');
        }
      } else {
        returnBool.add('false');
      }
    } catch (e) {
      print('err $e');
      returnBool.add('false');
    }

    return returnBool;
  }

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
    String url = MyWord.serverIpAndPort + '/getcontents';
    Map<String, String> map = {};
    map = {"sitekey": siteKey, "flag": flag, "getcontentcountplus": '$getContentCountPlus'};
    Uri uri = Uri.parse(url);
    try {
      var response = await http.post(uri, headers: map);
      int state = response.statusCode;
      print(response.statusCode);
      if (state == 200) {
        Map result = jsonDecode(response.body);
        //print(result);
        String approved = result.values.elementAt(0);
        List message = result.values.elementAt(1);
        List imgProfile = result.values.elementAt(2);
        print('=============================');
        //print(approved);
        if (approved == 'pass') {
          for (Map<dynamic, dynamic> element1 in message) {
            ContentDataModel contentDataModel = ContentDataModel.fromJson(element1);
            returnList.add(contentDataModel);
          }
          returnList.add(imgProfile);
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

  static Future<bool> userWithdrawal(String userId, String googleId) async {
    String flag = 'wdelete';
    String siteKey = 'secretKey';
    bool returnResult = false;
    String url = MyWord.serverIpAndPort + '/user';
    Map<String, String> map = {};
    map = {
      "siteKey": siteKey,
      "flag": flag,
      "id": userId,
      "googleAccessId": googleId,
    };
    try {
      var response = await http.post(Uri.parse(url), headers: map);
      int stateCode = response.statusCode;
      if (stateCode == 200) {
        Map responseValue = jsonDecode(response.body);
        if (responseValue.values.first.contains('pass')) {
          returnResult = true;
        } else if (responseValue.values.first.contains('no')) {
          returnResult = false;
        }
      }
    } catch (e) {
      print('deleteComment error :$e');
      returnResult = false;
    }
    return returnResult;
  }

//
  static Future<bool> deleteComment(int contentId, String userId, String commentSeq) async {
    String flag = 'deleteComment';
    String siteKey = 'secretKey';
    bool returnResult = false;
    String url = MyWord.serverIpAndPort + '/deletecomment';
    Map<String, String> map = {};
    map = {"siteKey": siteKey, "flag": flag, "contentid": '$contentId', "commentseq": commentSeq};
    try {
      var response = await http.post(Uri.parse(url), headers: map);
      int stateCode = response.statusCode;
      print('$stateCode pass');
      if (stateCode == 200) {
        Map responseValue = jsonDecode(response.body);
        if (responseValue.values.first.contains('pass')) {
          returnResult = true;
        } else {
          returnResult = false;
        }
      }
    } catch (e) {
      print('deleteComment error :$e');
      returnResult = false;
    }
    return returnResult;
  }

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
    String siteKey = 'secretKey'; //?????? ????????? ????????? ???????????? ????????? ????????? ???????????? ????????? ??????
    String url = MyWord.serverIpAndPort + '/deletecontent';
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

  static Future<List> setComment({required String value, required int index, required String userId}) async {
    String flag = 'setcomment';
    String siteKey = 'secretKey'; //?????? ????????? ????????? ???????????? ????????? ????????? ???????????? ????????? ??????
    String url = MyWord.serverIpAndPort + '/setcomment';
    List returnResult = [];
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
          var rere = responsePassCheck.values.elementAt(1);
          returnResult.add('pass');
          returnResult.add(rere);
        } else {
          returnResult.add('no');
        }
      } else {
        returnResult.add('not 200');
      }
    } catch (e) {
      print('setComment error :$e');
      returnResult.add('err');
    }
    return returnResult;
  }

  static Future<bool> setLikeAndBad({required int contentId, required int likeAndBadFlag, required int likeAndBadCount}) async {
    String flag = 'setlikeandbad';
    String siteKey = 'secretKey'; //?????? ????????? ????????? ???????????? ????????? ????????? ???????????? ????????? ??????
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

  static Future<List> signIn(String id, String pass) async {
    List returnInt = [];
    String flag = 'signIn';
    String siteKey = 'secretKey'; //?????? ????????? ????????? ???????????? ????????? ????????? ???????????? ????????? ??????
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
            //???????????? ????????? ?????? ??????
            returnInt.add(1);
          } else {
            //????????? ?????? ??????
            returnInt.add(2); //????????? ????????? ?????? ???????????? ??????????????? ??????!!
            print('??????!!!!!!!');
          }
        } else if (responsePassCheck.values.elementAt(0) == 'FE') {
          returnInt.add(0); //????????????
          print('FE!!!!!!!');
        } else if (responsePassCheck.values.elementAt(0) == 'SK') {
          returnInt.add(0); //????????????
          print('SK!!!!!!!');
        }
      } else {
        returnInt.add(0); // 200 ??????
      }
    } catch (e) {
      print('signIn err : $e');
      returnInt.add(0); // ?????? ?????? ??????
    }
    return returnInt;
  }

//
  static Future<int> doubleCheck(String id) async {
    int result = 0;
    String flag = 'doublecheck';
    String siteKey = 'secretKey'; //?????? ????????? ????????? ???????????? ????????? ????????? ???????????? ????????? ??????
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
            //???????????? ??????????????? ??????
            result = 2; //????????? ????????? ???????????? ???????????? ?????????
          } else {
            //????????? ?????? ??????
            result = 1; //????????? ????????? ????????? ???????????? ?????? ??????
          }
        } else {
          result = 0; //????????????
        }
      } else {
        result = 0; //????????????
      }
    } catch (e) {
      print('signup err : $e');
      result = 0; //????????????
    }
    return result;
  }

  static Future<bool> signUp(String id, String pass) async {
    bool result = false;
    String flag = 'signup';
    String siteKey = 'secretKey'; //?????? ????????? ????????? ???????????? ????????? ????????? ???????????? ????????? ??????
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
          result = false; //????????????
        }
      }
    } catch (e) {
      print('signup err : $e');
    }
    return result;
  }
}
