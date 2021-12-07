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
  List<int> userIndexContentId = [];
  bool firstPass = true;

  void setComment({required int contentIndex, required String comment, required String userId, required int pageListIndex}) async {
    print('setcomment pass?? $contentIndex // len? ${contentDataModelList.length}');
    List result = await NodeServer.setComment(userId: userId, index: contentIndex, value: comment);
    String result2 = result.first;
    if(result2 == 'pass'){
      String commentSeq = result.last;
      commentSeq.trim();

      ContentDataModel contentDataModel = contentDataModelList.elementAt(pageListIndex);
        List<dynamic> commentDataList = contentDataModel.comment;
        print('11111 ${commentDataList.length}');
        List contentEncode = utf8.encode(comment);
        Map<dynamic, dynamic> map = {
          'visible': '1',
          'createTime': DateTime.now().millisecondsSinceEpoch.toString(),
          'userId': userId,
          'comment': '$contentEncode',
          'commentSeq': commentSeq,
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
        print('44444');
        contentDataModelList.removeAt(pageListIndex);
        contentDataModelList.insert(pageListIndex, contentDataModel2);
        notifyListeners();

    }else{
      // 뭔가모를 에러
    }

  }

  void deleteComment(int contentId, String userId, String commentSeq, int commentIndex, int contentIndex) async {
    bool result = await NodeServer.deleteComment(contentId, userId, commentSeq);
    if(result){

      ContentDataModel contentDataModel = contentDataModelList.elementAt(contentIndex);
      List<dynamic> commentDataList = contentDataModel.comment;
      commentDataList.removeAt(commentIndex);

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

      contentDataModelList.removeAt(contentIndex);
      contentDataModelList.insert(contentIndex, contentDataModel2);
      notifyListeners();

    }else{

    }

  }

  void repeat(String userId) {
    for (int i = 0; i < contentDataModelList.length; i++) {
      ContentDataModel contentDataModel = contentDataModelList.elementAt(i);
      if (contentDataModel.userId == userId) {
        contentDataModelList.removeAt(i);
      }
    }
  }

  void deleteUserAllContent(String userId) {
    for (int i = 0; i < 10; i++) {
      repeat(userId);
    }
    notifyListeners();
  }

  void deleteUserContent(int contentId) {
    for (int i = 0; i < contentDataModelList.length; i++) {
      ContentDataModel contentDataModel = contentDataModelList.elementAt(i);
      if (contentDataModel.contentId == contentId) {
        //이때 구하는 i 가 순번
        contentDataModelList.removeAt(i);
      }
    }
    notifyListeners();
  }

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
}
