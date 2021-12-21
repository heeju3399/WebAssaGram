import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/dialog/dialog.dart';

class MobileUserCommentPage extends StatefulWidget {
  const MobileUserCommentPage({Key? key}) : super(key: key);

  @override
  _MobileUserCommentPageState createState() => _MobileUserCommentPageState();
}

class _MobileUserCommentPageState extends State<MobileUserCommentPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  void addComment(
      String value, UserContentProvider userContentProvider, String userId, ContentDataModel contentData, ContentProvider contentProvider) {
    if (value == '' && value.isEmpty) {
      value = textEditingController.text;
    }

    if (userId == MyWord.LOGIN) {
      MyDialog.setContentDialog(title: '익명으로는 사용할수 없어요', message: '댓글은 로그인후 이용가능합니다', context: context);
    } else {
      int index = userContentProvider.contentPageIndex;
      contentProvider.setComment(contentIndex: contentData.contentId, comment: value, userId: userId, pageListIndex: index).then((result2) => {
            if (result2) {userContentProvider.setComment(index, value, userId)}
          });
    }
  }

  String profileImageSearch(ContentProvider contentProvider, String userId) {
    String returnString = '';
    List ssd = contentProvider.profileImageList;

    for (var element in ssd) {
      String userid5 = element['userId'];
      if (userId == userid5) {
        Map map = element['images'];
        String imgString = map.values.elementAt(5).toString();
        returnString = MyWord.serverIpAndPort + '/view/$imgString';
        break;
      } else {
        returnString = '';
      }
    }
    if (returnString == '') {
      returnString = MyWord.serverIpAndPort + '/view/basic.png';
    }
    return returnString;
  }

  @override
  Widget build(BuildContext context) {
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);

    List contentDataList = userContentProvider.userContentDataList;
    int mainIndex = userContentProvider.userChooseContentIndex;
    ContentDataModel contentData = contentDataList[mainIndex];

    double ss = MediaQuery.of(context).size.height;
    print('height@@ : $ss');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('댓글'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: ss - 140,
                child: ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: contentData.comment.length,
                    itemBuilder: (context, commentIndex) {
                      Map element = contentData.comment[commentIndex];
                      CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
                      String agoDate = ContentControl.contentTimeStamp(commentDataModel.createTime);
                      List<dynamic> utf8List2 = jsonDecode(commentDataModel.comment);
                      List<int> intList = [];
                      for (var element in utf8List2) {
                        intList.add(element);
                      }
                      String commentString = utf8.decode(intList);
                      String profileImageUri = '';
                      profileImageUri = ContentControl.redefineComment(contentProvider, commentDataModel);

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(profileImageUri)))),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${commentDataModel.userId}  $commentString',
                                      overflow: TextOverflow.clip, style: const TextStyle(color: Colors.white, fontSize: 15)),
                                  Text(agoDate, style: const TextStyle(color: Colors.white, fontSize: 15))
                                ],
                              )),
                        ]),
                      );
                    }),
              ),
              SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 7,
                          child: Container(
                              color: Colors.red,
                              child: Container(
                                  color: Colors.black,
                                  //decoration: const BoxDecoration(color: Colors.black),
                                  child: TextField(
                                      focusNode: focusNode,
                                      controller: textEditingController,
                                      onSubmitted: (v) {
                                        addComment(v, userContentProvider, userProvider.userId, contentData, contentProvider);
                                        textEditingController.clear();
                                        focusNode.requestFocus();
                                      },
                                      style: const TextStyle(fontSize: 15, color: Colors.white),
                                      decoration: const InputDecoration(
                                          hintText: '입력 후 엔터',
                                          hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(1.0)),
                                            // borderSide: BorderSide(width: 1, color: Colors.white)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(1.0)),
                                            //borderSide: BorderSide(width: 1, color: Colors.white)
                                          ),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(1.0)))))))),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: () {
                                addComment(textEditingController.text, userContentProvider, userProvider.userId, contentData, contentProvider);
                                textEditingController.clear();
                                focusNode.requestFocus();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ))),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
