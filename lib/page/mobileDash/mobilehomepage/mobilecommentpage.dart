import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/dialog/dialog.dart';

class MobileDifCommentPage extends StatefulWidget {
  const MobileDifCommentPage({Key? key}) : super(key: key);

  @override
  State<MobileDifCommentPage> createState() => _MobileDifCommentPageState();
}

class _MobileDifCommentPageState extends State<MobileDifCommentPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool myIdCheck = false;
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ContentDataModel contentData = contentProvider.contentDataModelList[contentProvider.contentIndex];
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
                      String profileImageUri = '';
                      profileImageUri = ContentControl.redefineComment(contentProvider, commentDataModel);
                      String agoDate = ContentControl.contentTimeStamp(commentDataModel.createTime);
                      if (userProvider.userId == commentDataModel.userId) {
                        myIdCheck = false;
                      } else {
                        myIdCheck = true;
                      }
                      List<dynamic> utf8List2 = jsonDecode(commentDataModel.comment);
                      List<int> intList = [];
                      for (var element in utf8List2) {
                        intList.add(element);
                      }
                      String commentString = utf8.decode(intList);
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
                                  Text(
                                      '${commentDataModel.userId}  $commentString',
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                                  myIdCheck
                                      ? Text(agoDate, style: const TextStyle(color: Colors.white, fontSize: 15))
                                      : TextButton(
                                          onPressed: () {
                                            contentProvider.deleteComment(
                                                contentData.contentId, userProvider.userId, commentDataModel.commentSeq, commentIndex, contentProvider.contentIndex);
                                          },
                                          child: const Text('지우기', style: TextStyle(color: Colors.red, fontSize: 15))),
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
                                        if (v != '' && v.isNotEmpty) {
                                          if (userProvider.userId != MyWord.LOGIN) {
                                            contentProvider.setComment(
                                                contentIndex: contentData.contentId, comment: v,
                                                userId: userProvider.userId, pageListIndex: contentProvider.contentIndex);
                                            textEditingController.clear();
                                            focusNode.requestFocus();
                                          } else {
                                            textEditingController.clear();
                                            MyDialog.setContentDialog(title: '접속불가', message: '로그인 부탁드려요', context: context);
                                          }
                                        }
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
                                if (textEditingController.text != '' && textEditingController.text.isNotEmpty) {
                                  if (userProvider.userId != MyWord.LOGIN) {
                                    contentProvider.setComment(
                                        contentIndex: contentData.contentId, comment: textEditingController.text,
                                        userId: userProvider.userId, pageListIndex: contentProvider.contentIndex);
                                    textEditingController.clear();
                                    focusNode.requestFocus();
                                  } else {
                                    textEditingController.clear();
                                    MyDialog.setContentDialog(title: '접속불가', message: '로그인 부탁드려요', context: context);
                                  }
                                }
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
