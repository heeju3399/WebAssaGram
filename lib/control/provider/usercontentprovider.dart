import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/server/nodeserver.dart';
import 'contentprovider.dart';

// ignore_for_file: avoid_print
class UserContentProvider extends ChangeNotifier {
  List<dynamic> userContentDataList = [];
  List profileImage = [];

  bool downEnd = true;
  bool upEnd = true;
  bool init = true;
  String userProfileImageUri = '';
  int getContentCountPlus = 100;
  int contentPageIndex = 0;
  int userChooseContentIndex = 0;
  int contentCount = 0;
  int commentCount = 0;
  int viewCount = 0;
  int likeCount = 0;
  int badCount = 0;

  void setUserContent(int index){
    userChooseContentIndex = index;
  }

  void setProfileImageString(String imageString){
    userProfileImageUri = imageString;
  }

  void initProfileImage(ContentProvider contentProvider, String userId) {
    if(init){
      print('initProfileImage');
      String imgString = '';
      List profileImageList = contentProvider.profileImageList;
      for (var element in profileImageList) {
        String userid5 = element['userId'];
        if (userId == userid5) {
          Map map = element['images'];
          imgString = map.values.elementAt(5).toString();
          userProfileImageUri = MyWord.serverIpAndPort+'/view/$imgString';
          break;
        } else {
          userProfileImageUri = '';
        }
      }
      if (userProfileImageUri == '') {
        userProfileImageUri = MyWord.serverIpAndPort+'/view/basic.png';
      }
      init = false;
    }
  }

  Future<bool> deleteProfileImage(String userId, String googleAccessId) async {
    bool returnBool = false;
    bool result = await NodeServer.deleteProfileImage(userId, googleAccessId);
    if(result){
      userProfileImageUri = '';
      returnBool = true;
    }else{

    }
    notifyListeners();
    return returnBool;

  }

  void setProfileImage(String userId, String googleAccessId, XFile image) async {
    List resultList = await NodeServer.setProfileImage(userId, googleAccessId, image);
    if (resultList.elementAt(0) == 'true') {
      String profileImgUrl = resultList.elementAt(1).toString();
      userProfileImageUri = MyWord.serverIpAndPort+'$profileImgUrl';
      notifyListeners();
    } else {}
  }

  Future<bool> deleteAllContent(String userId) async {
    bool returnBool = false;
    await NodeServer.deleteAllContent(userId).then((value) {
      if (value) {
        userContentDataList.clear();
        contentCount = 0;
        viewCount = 0;
        likeCount = 0;
        badCount = 0;
        commentCount = 0;
        returnBool = true;
      }
    });
    notifyListeners();
    return returnBool;
  }

  void deleteContent(int index, String userId, int contentId) async {
    await NodeServer.deleteContent(contentId, userId).then((value) {
      if (value) {
        userContentDataList.removeAt(index);
        int contentCount = 0;
        int viewCount = 0;
        int likeCount = 0;
        int badCount = 0;
        int commentCount = 0;
        contentCount = userContentDataList.length;
        for (ContentDataModel contentData in userContentDataList) {
          viewCount = contentData.viewCount + viewCount;
          likeCount = contentData.likeCount + likeCount;
          badCount = contentData.badCount + badCount;
          commentCount = contentData.comment.length + commentCount;
        }
        this.contentCount = contentCount;
        this.viewCount = viewCount;
        this.likeCount = likeCount;
        this.badCount = badCount;
        this.commentCount = commentCount;
        notifyListeners();
      }
    });
  }

  void setLike(int index, int likeAndBadCount) async {
    likeAndBadCount = likeAndBadCount + 1;
    ContentDataModel contentDataModel = userContentDataList.elementAt(index);
    ContentDataModel contentDataModel2 = ContentDataModel(
        contentId: contentDataModel.contentId,
        userId: contentDataModel.userId,
        images: contentDataModel.images,
        nicName: contentDataModel.nicName,
        comment: contentDataModel.comment,
        createTime: contentDataModel.createTime,
        visible: contentDataModel.visible,
        viewCount: contentDataModel.viewCount,
        content: contentDataModel.content,
        likeCount: likeAndBadCount,
        badCount: contentDataModel.badCount);
    userContentDataList.removeAt(index);
    userContentDataList.insert(index, contentDataModel2);

    notifyListeners();
  }

  void setComment(int index, String value, String userId) {
    ContentDataModel contentDataModel = userContentDataList.elementAt(index);
    List<dynamic> commentDataList = contentDataModel.comment;
    List contentEncode = utf8.encode(value);
    Map<dynamic, dynamic> map = {
      'visible': '1',
      'createTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'comment': '$contentEncode',
      'commentSeq': 'ok',
    };

    commentDataList.insert(0, map);
    ContentDataModel contentDataModel2 = ContentDataModel(
        contentId: contentDataModel.contentId,
        userId: contentDataModel.userId,
        images: contentDataModel.images,
        nicName: contentDataModel.nicName,
        comment: commentDataList,
        createTime: contentDataModel.createTime,
        visible: contentDataModel.visible,
        viewCount: contentDataModel.viewCount,
        content: contentDataModel.content,
        likeCount: contentDataModel.likeCount,
        badCount: contentDataModel.badCount);

    userContentDataList.removeAt(index);
    userContentDataList.insert(index, contentDataModel2);

    notifyListeners();
  }

  void setPage(int pageIndex) {
    contentPageIndex = pageIndex;
    notifyListeners();
  }

  void changePageUp() {
    if (userContentDataList.length > contentPageIndex + 1) {
      contentPageIndex++;
    } else {
      contentPageIndex == 0;
      print('changePageUp end?');
      upEnd = false;
    }
    notifyListeners();
  }

  void changePageDown() {
    if (contentPageIndex == 0) {
      contentPageIndex = 0;
      print('changePageDown end?');
      downEnd = false;
    } else {
      contentPageIndex--;
      upEnd = true;
    }
    notifyListeners();
  }

  void initGetContent(String userId) async {
    print('user content init pass $userId');
    String notApproved = 'not pass';
    String stateErr = 'state err';
    String serverConnectFail = 'server connect fail';
    var result = await NodeServer.getUserContent(getContentCountPlus, userId);
    if (result.contains(notApproved)) {
      print(notApproved);
    } else if (result.contains(stateErr)) {
      print(stateErr);
    } else if (result.contains(serverConnectFail)) {
      print(serverConnectFail);
    } else {
      print('pass');
      userContentDataList = result;
      int contentCount = 0;
      int viewCount = 0;
      int likeCount = 0;
      int badCount = 0;
      int commentCount = 0;
      contentCount = userContentDataList.length;
      for (ContentDataModel contentData in userContentDataList) {
        viewCount = contentData.viewCount + viewCount;
        likeCount = contentData.likeCount + likeCount;
        badCount = contentData.badCount + badCount;
        commentCount = contentData.comment.length + commentCount;
      }
      this.contentCount = contentCount;
      this.viewCount = viewCount;
      this.likeCount = likeCount;
      this.badCount = badCount;
      this.commentCount = commentCount;
    }
    notifyListeners();
  }

  void refresh() async {
    notifyListeners();
  }
}
