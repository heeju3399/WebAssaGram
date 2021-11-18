import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:realproject/control/content.dart';
import 'package:realproject/model/content.dart';
import 'package:realproject/model/maincontenttilecolor.dart';
import 'package:realproject/model/shared.dart';

class ProFile extends StatefulWidget {
  const ProFile({Key key, this.userId}) : super(key: key);
  static String routeName = '/ProFile';
  final String userId;

  @override
  _ProFileState createState() => _ProFileState(userId: userId);
}

class _ProFileState extends State<ProFile> {
  _ProFileState({this.userId});

  MyShared myShared = MyShared();
  bool reload = true;
  final String userId;
  int contentId2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

            backgroundColor: Colors.black,
            title: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Text(' $userId 님의 글 ', maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(color: Colors.white))),
            actions: [
              TextButton(
                  onPressed: () {
                    myShared.setUserId('LogIn');
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: 100,
                      height: 20,
                      alignment: Alignment.center,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('로그아웃', style: TextStyle(color: Colors.white))
                      ]))),
            ]),
        backgroundColor: Colors.black,
        body: reload ? SingleChildScrollView(child: Column(children: [header(), body(), bottom(), Divider()])) : CircularProgressIndicator());
  }

  Center header() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('길게 누르면 지워집니다', maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontSize: 15, color: Colors.white))),
    );
  }

  Row bottom() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
            width: 110,
            height: 40,
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextButton(
                onPressed: () {
                  contentAllDelete(contentId2);
                },
                child: Text('전체삭제', style: TextStyle(color: Colors.white)))),
      ),
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
            width: 110,
            height: 40,
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextButton(
                onPressed: () {
                  userDelete(context);
                },
                child: Text('회원탈퇴', style: TextStyle(color: Colors.white)))),
      )
    ]);
  }

  Padding body() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
            future: MainContentControl.getUserContents(userId: userId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ));
              } else {
                List data22 = snap.data as List;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    MainContentDataModel item = data22[index];
                    return _mainMobileBuild(context: context, item: item, index: index);
                  },
                  itemCount: data22.length,
                  shrinkWrap: true,
                );
              }
            }));
  }

  Widget _mainMobileBuild({MainContentDataModel item, int index, BuildContext context}) {
    List<dynamic> utf8Decode = jsonDecode(item.content);
    List<int> intList = [];
    utf8Decode.forEach((element) {
      intList.add(element);
    });
    String utf8StringContent = utf8.decode(intList).toString();
    contentId2 = item.contentId;
    return InkWell(
        onLongPress: () {
          contentDelete(item.contentId);
        },
        child: Card(
            color: Colors.white12,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$utf8StringContent',
                          maxLines: 5, overflow: TextOverflow.clip, style: TextStyle(color: MainContentWidgetModel.textColor))),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Icon(Icons.favorite, size: 15, color: MainContentWidgetModel.iconColor),
                        Text('  ( ${item.likeCount} )', style: TextStyle(color: MainContentWidgetModel.textColor, fontSize: 12)),
                        Padding(
                            padding: const EdgeInsets.only(left: 15), child: Icon(Icons.mood_bad, size: 15, color: MainContentWidgetModel.iconColor)),
                        Text('  ( ${item.badCount} )', style: TextStyle(color: MainContentWidgetModel.textColor, fontSize: 12)),
                        Padding(
                            padding: const EdgeInsets.only(left: 15), child: Icon(Icons.comment, size: 15, color: MainContentWidgetModel.iconColor)),
                        Text('  ( ${item.children.length} )', style: TextStyle(color: MainContentWidgetModel.textColor, fontSize: 12)),
                      ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(padding: const EdgeInsets.only(left: 30), child: MainContentWidgetModel.myText(item.createTime)),
                    ],
                  )
                ]))));
  }

  void refreshMethod() async {
    setState(() {
      reload = false;
    });
    await Future.delayed(Duration(milliseconds: 5));
    setState(() {
      reload = true;
    });
  }

  void contentDelete(int contentId) {
    MainContentControl.deleteContent(contentId, userId);
    refreshMethod();
  }

  void contentAllDelete(int contentId) {
    MainContentControl.deleteAllContent(contentId, userId);
    refreshMethod();
  }

  void userDelete(BuildContext context) async {
    await MainContentControl.userDelete(userId: userId).then((value) => {
      if(value){
        Navigator.of(context).pop()
      }
    });


  }
}
