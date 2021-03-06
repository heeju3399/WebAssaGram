import 'package:flutter/material.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/model/ranker.dart';
import 'package:web/server/nodeserver.dart';

// ignore_for_file: avoid_print
class RankerProvider extends ChangeNotifier {
  RankerProvider() {
    initGetRankerContent();
  }

  int getRankerContentCountPlus = 10;
  List rankerContentList = [];
  List profileImageList = [];
  List rankerDetailContentList = [];
  List profileImageListStringUri = [];
  int detailIndex = 0;
  int skipIndexForServer = 10;

  void setDetailIndex(int index) {
    detailIndex = index;
  }

  void setProfileImageList(List profileImageList) {
    this.profileImageList = profileImageList;
  }

  void initGetRankerContent() async {
    String notApproved = 'not pass';
    String stateErr = 'state err';
    String serverConnectFail = 'server connect fail';
    var result = await NodeServer.getRankerProfileAndContentInit(getRankerContentCountPlus);
    if (result.contains(notApproved)) {
      print(notApproved);
    } else if (result.contains(stateErr)) {
      print(stateErr);
    } else if (result.contains(serverConnectFail)) {
      print(serverConnectFail);
    } else {
      print('pass');
      for (var element in result.first) {
        ContentDataModel contentDataModel = ContentDataModel.fromJson(element);
        rankerDetailContentList.add(contentDataModel);
        String userProfileImageUri = '';
        for (var element in profileImageList) {
          String userid5 = element['userId'];
          if (contentDataModel.userId == userid5) {
            Map map = element['images'];
            String imgString = map.values.elementAt(5).toString();
            userProfileImageUri = MyWord.imagesServerIpAndPort + imgString;
            break;
          } else {
            userProfileImageUri = '';
          }
        }
        if (userProfileImageUri == '') {
          userProfileImageUri =  MyWord.imagesServerIpAndPort+'basic.png';
        }
        profileImageListStringUri.add(userProfileImageUri);

        ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataModel.images[0]);
        String fileName = imagesDataModel.filename;
        String urlString =  MyWord.imagesServerIpAndPort+fileName;

        RankerContentDataModel rankerContentDataModel = RankerContentDataModel(
            contentId: contentDataModel.contentId,
            userId: contentDataModel.userId,
            content: contentDataModel.content,
            likeCount: contentDataModel.likeCount,
            profileImageStringUri: userProfileImageUri,
            contentImageStringUri: urlString);
        rankerContentList.add(rankerContentDataModel);
      }
      //????????????!
    }
    notifyListeners();
    getRankerContentCountPlus = getRankerContentCountPlus + 10;
  }

  void getRankerContent() async {
    String notApproved = 'not pass';
    String stateErr = 'state err';
    String serverConnectFail = 'server connect fail';
    var result = await NodeServer.getTenRankerProfileAndContent(skipIndexForServer);
    if (result.contains(notApproved)) {
      print(notApproved);
    } else if (result.contains(stateErr)) {
      print(stateErr);
    } else if (result.contains(serverConnectFail)) {
      print(serverConnectFail);
    } else {
      print('pass');
      for (var element in result.first) {
        ContentDataModel contentDataModel = ContentDataModel.fromJson(element);
        rankerDetailContentList.add(contentDataModel);
        String userProfileImageUri = '';
        for (var element in profileImageList) {
          String userid5 = element['userId'];
          if (contentDataModel.userId == userid5) {
            Map map = element['images'];
            String imgString = map.values.elementAt(5).toString();
            userProfileImageUri =  MyWord.imagesServerIpAndPort+imgString;
            break;
          } else {
            userProfileImageUri = '';
          }
        }
        if (userProfileImageUri == '') {
          userProfileImageUri =  MyWord.imagesServerIpAndPort+'basic.png';
        }
        profileImageListStringUri.add(userProfileImageUri);

        ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataModel.images[0]);
        String fileName = imagesDataModel.filename;
        String urlString = MyWord.imagesServerIpAndPort+fileName;
        RankerContentDataModel rankerContentDataModel = RankerContentDataModel(
            contentId: contentDataModel.contentId,
            userId: contentDataModel.userId,
            content: contentDataModel.content,
            likeCount: contentDataModel.likeCount,
            profileImageStringUri: userProfileImageUri,
            contentImageStringUri: urlString);
        rankerContentList.add(rankerContentDataModel);
      }
    }
    notifyListeners();
    skipIndexForServer = skipIndexForServer + 10;
  }
}
