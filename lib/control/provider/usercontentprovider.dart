import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:web/model/content.dart';
import 'package:web/server/nodeserver.dart';

class UserContentProvider extends ChangeNotifier {
  List<dynamic> userContentDataList = [];
  int getContentCountPlus = 100;
  int contentPageIndex = 0;
  bool upEnd = true;
  bool downEnd = true;
  String userProfileImage = ''; //아직 비었음

  int contentCount = 0;
  int viewCount = 0;
  int likeCount = 0;
  int badCount = 0;
  int commentCount = 0;

  Future<bool> deleteAllContent(String userId) async {
    bool returnBool = false;
    await NodeServer.deleteAllContent(userId).then((value) {
      print('value???????? $value');
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
      print('value???????? $value');
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
    print('int alike count ${likeAndBadCount}');
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
    print('result?????????? ${result}');
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

  // void getUserContent(String userId) async {
  //   print('====================provider getcontent pass======================');
  //   String notApproved = 'not pass';
  //   String stateErr = 'state err';
  //   String serverConnectFail = 'server connect fail';
  //   var result = await NodeServer.getUserContent(getContentCountPlus, userId);
  //   if (result.contains(notApproved)) {
  //     print(notApproved);
  //   } else if (result.contains(stateErr)) {
  //     print(stateErr);
  //   } else if (result.contains(serverConnectFail)) {
  //     print(serverConnectFail);
  //   } else {
  //     print('pass');
  //     userContentDataList = result;
  //   }
  //   notifyListeners();
  //   getContentCountPlus = getContentCountPlus + 6;
  // }

  void refresh() async {
    notifyListeners();
  }
}
