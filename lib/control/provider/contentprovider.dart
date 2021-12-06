import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web/model/content.dart';
import 'package:web/server/nodeserver.dart';

class ContentProvider extends ChangeNotifier {
  ContentProvider() {
    initGetContent();
  }

  List<dynamic> contentDataModelList = [];
  int getContentCountPlus = 5;
  List<Map> indexContentId = [];
  bool firstPass = true;

  // void setIndexContentId(int index, int contentId) {
  //     Map<int, int> map = {index: contentId};
  //     indexContentId.add(map);
  // }
  //
  // void viewoksk() {
  //   print('indexContentId?? $indexContentId');
  // }

  // void deleteMainContent(int contentId) {
  //   int aa = 99999;
  //   for (var map in indexContentId) {
  //     map.forEach((index, contentIdValue) {
  //       print('value?!! $index // contentid $contentIdValue');
  //       if(contentIdValue == contentId){
  //         aa = index;
  //         print('이놈이다 $index');
  //       }
  //     });
  //   }
  //   contentDataModelList.removeAt(aa);
  //   notifyListeners();
  // }

  void initGetContent() async {
    String notApproved = 'not pass';
    String stateErr = 'state err';
    String serverConnectFail = 'server connect fail';
    var result = await NodeServer.getContent(getContentCountPlus);
    if (result.contains(notApproved)) {
      print(notApproved);
    } else if (result.contains(stateErr)) {
      print(stateErr);
    } else if (result.contains(serverConnectFail)) {
      print(serverConnectFail);
    } else {
      print('pass');
      contentDataModelList = result;
    }

    notifyListeners();
    getContentCountPlus = getContentCountPlus + 5;
  }

  void getContent() async {
    print('====================provider getcontent pass======================');
    String notApproved = 'not pass';
    String stateErr = 'state err';
    String serverConnectFail = 'server connect fail';
    var result = await NodeServer.getContent(getContentCountPlus);
    if (result.contains(notApproved)) {
      print(notApproved);
    } else if (result.contains(stateErr)) {
      print(stateErr);
    } else if (result.contains(serverConnectFail)) {
      print(serverConnectFail);
    } else {
      print('pass');
      contentDataModelList = result;
    }
    notifyListeners();
    getContentCountPlus = getContentCountPlus + 5;
  }

  void refresh() async {
    notifyListeners();
  }

  void setLikeAndBad(int flag, int index, int likeAndBadCount) async {
    likeAndBadCount = likeAndBadCount + 1;
    ContentDataModel contentDataModel = contentDataModelList.elementAt(index);
    if (flag == 0) {
      //like
      //print('like pass');
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
      contentDataModelList.removeAt(index);
      contentDataModelList.insert(index, contentDataModel2);
    } else {
      //bad
      //print('bad pass');
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
          likeCount: contentDataModel.likeCount,
          badCount: likeAndBadCount);
      contentDataModelList.removeAt(index);
      contentDataModelList.insert(index, contentDataModel2);
    }

    notifyListeners();
  }

  void setComment({required int contentIndex, required String comment, required String userId}) async {
    ContentDataModel contentDataModel = contentDataModelList.elementAt(contentIndex);
    print('0000');
    List<dynamic> commentDataList = contentDataModel.comment;
    print('11111 ${commentDataList.length}');
    List contentEncode = utf8.encode(comment);
    Map<dynamic, dynamic> map = {
      'visible': '1',
      'createTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'comment': '$contentEncode',
      'commentSeq': 9999,
    };

    CommentDataModel commentDataModel22 = CommentDataModel.fromJson(map);
    print('22222');
    commentDataList.insert(0, map);
    print('33333');
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
    print('44444');
    contentDataModelList.removeAt(contentIndex);
    contentDataModelList.insert(contentIndex, contentDataModel2);

    notifyListeners();
  }
}
