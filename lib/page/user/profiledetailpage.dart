import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/icons.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/dialog/dialog.dart';
import '../../responsive.dart';

// ignore_for_file: avoid_print
class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  bool selected = false;
  bool pageIsScrolling = false;
  bool onePass = true;
  TextEditingController textEditCommentController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    timer();
  }

  void timer() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    return Responsive.isLarge(context) ? windows(userContentProvider, userProvider, contentProvider) : mobile();
  }

  PageController pageController2 = PageController();
  int imagesPage = 0;

  Widget images(ContentDataModel contentData) {
    List imageContent = contentData.images; //하나의 콘텐트 안에 이미지 겟수

    List urlList = [];
    for (var element in imageContent) {
      ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(element);
      String fileName = imagesDataModel.filename;
      String urlString = 'http://172.30.1.19:3000/view/$fileName';
      urlList.add(urlString);
    }
    return PageView.builder(
      itemCount: imageContent.length,
      controller: pageController2,
      itemBuilder: (context, index2) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
                shape: BoxShape.rectangle,
                image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(urlList[index2]))));
      },
    );
  }

  void addComment(
      String value, UserContentProvider userContentProvider, String userId, ContentDataModel contentData, ContentProvider contentProvider) {
    if (value == '' && value.isEmpty) {
      value = textEditCommentController.text;
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

  Widget commentListView(ContentDataModel contentData) {
    return ListView.builder(
        itemCount: contentData.comment.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map element = contentData.comment[index];
          CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
          String agoDate = ContentControl.contentTimeStamp(commentDataModel.createTime);
          List<dynamic> utf8List2 = jsonDecode(commentDataModel.comment);
          List<int> intList = [];
          for (var element in utf8List2) {
            intList.add(element);
          }
          String commentString = utf8.decode(intList);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(4, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Text(
                          commentDataModel.userId,
                          style: const TextStyle(color: Colors.lightGreenAccent),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text(commentString, style: const TextStyle(color: Colors.white, fontSize: 15))),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(" - $agoDate - ", style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget windows(UserContentProvider userContentProvider, UserProvider userProvider, ContentProvider contentProvider) {
    print('window apss : ${userContentProvider.userContentDataList.length}');
    List contentDataList = userContentProvider.userContentDataList;
    int index = userContentProvider.contentPageIndex;
    ContentDataModel contentData = contentDataList[index];
    String contentId = contentData.userId;
    String profileImage = profileImageSearch(contentProvider, contentId);

    return Scaffold(
      backgroundColor: Colors.black12.withOpacity(0.8),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            AnimatedPositioned(
              top: selected ? 100 : 500,
              bottom: selected ? 100 : 500,
              right: selected ? 100 : 500,
              left: selected ? 100 : 500,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: AnimatedOpacity(
                opacity: selected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(width: 1, color: Colors.black)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                  child: AnimatedOpacity(
                                      opacity: selected ? 1.0 : 0.0, duration: const Duration(milliseconds: 500), child: images(contentData))),
                              AnimatedPositioned(
                                  right: 10,
                                  top: 450,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                  child: GestureDetector(
                                      onTap: () {
                                        pageController2.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                      },
                                      child: AnimatedOpacity(
                                          opacity: selected ? 1.0 : 0.0,
                                          duration: const Duration(milliseconds: 500),
                                          child: const Icon(Ionicons.arrow_forward_circle_sharp, color: Colors.grey, size: 40)))),
                              AnimatedPositioned(
                                  left: 10,
                                  top: 450,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                  child: GestureDetector(
                                      onTap: () {
                                        pageController2.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                      },
                                      child: AnimatedOpacity(
                                          opacity: selected ? 1.0 : 0.0,
                                          duration: const Duration(milliseconds: 500),
                                          child: const Icon(Ionicons.arrow_back_circle_sharp, color: Colors.grey, size: 40))))
                            ],
                          ),
                          flex: 2),
                      Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                    decoration:
                                        const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                print(' user id pass ');
                                              },
                                              child: Row(
                                                children: [
                                                  Flexible(child: Container(width: 10), flex: 1),
                                                  Flexible(
                                                      flex: 3,
                                                      child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(profileImage))))),
                                                  Flexible(child: Container(width: 10), flex: 1),
                                                  Expanded(
                                                      child: Text(contentData.userId,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.clip,
                                                          textScaleFactor: 2,
                                                          style: const TextStyle(color: Colors.black)),
                                                      flex: 8)
                                                ],
                                              ),
                                            ),
                                            flex: 1),
                                      ],
                                    ),
                                  ),
                                  flex: 10),
                              const Divider(height: 1),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: commentListView(contentData),
                                ),
                                flex: 70,
                              ),
                              const Divider(
                                height: 1,
                              ),
                              Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(children: [
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Flexible(
                                                child: IconButton(
                                                    onPressed: () {
                                                      print('love pass');
                                                      ContentControl.setLikeAndBad(
                                                              flag: 0, contentId: contentData.contentId, likeAndBad: contentData.likeCount)
                                                          .then((value) => {
                                                                if (value == 'ok') {userContentProvider.setLike(index, contentData.likeCount)}
                                                              });
                                                    },
                                                    icon: const Icon(Icons.favorite_border))),
                                            Flexible(child: Text('( ${contentData.likeCount} )')),
                                          ],
                                        ),
                                        flex: 1,
                                      ),
                                      Flexible(
                                          child: Row(
                                            children: [
                                              const Flexible(child: Icon(Icons.message)),
                                              Flexible(child: Text('( ${contentData.comment.length} )')),
                                            ],
                                          ),
                                          flex: 1),
                                      Flexible(
                                          child: Row(
                                            children: [
                                              const Flexible(child: Icon(DIcons.remove_red_eye)),
                                              Flexible(child: Text('( ${contentData.viewCount} )')),
                                            ],
                                          ),
                                          flex: 1),
                                      //Flexible(flex: 1,child: Container()),
                                    ]),
                                  ),
                                  flex: 10),
                              const Divider(height: 1),
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 9,
                                            child: TextField(
                                                controller: textEditCommentController,
                                                focusNode: myFocusNode,
                                                onSubmitted: (v) {
                                                  addComment(v, userContentProvider, userProvider.userId, contentData, contentProvider);
                                                  textEditCommentController.clear();
                                                  myFocusNode.requestFocus();
                                                },
                                                style: const TextStyle(fontSize: 20),
                                                decoration: const InputDecoration(
                                                  labelText: '댓글',
                                                  labelStyle: TextStyle(fontSize: 15),
                                                ))),
                                        Expanded(
                                            flex: 1,
                                            child: IconButton(
                                                onPressed: () {
                                                  print('send pass');
                                                  addComment('', userContentProvider, userProvider.userId, contentData, contentProvider);
                                                  textEditCommentController.clear();
                                                  myFocusNode.requestFocus();
                                                },
                                                icon: const Icon(Icons.send)))
                                      ])),
                                  flex: 10)
                            ],
                          ),
                          flex: 1)
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
                right: selected ? 20 : 0,
                top: selected ? 20 : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: GestureDetector(
                    onTap: () {
                      pageDown();
                    },
                    child: AnimatedOpacity(
                        opacity: selected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(Icons.cancel, color: Colors.red, size: 60)))),
            AnimatedPositioned(
                right: selected ? 10 : 0,
                top: selected ? 420 : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: GestureDetector(
                    onTap: () {
                      userContentProvider.changePageUp();
                    },
                    child: AnimatedOpacity(
                        opacity: selected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(Ionicons.arrow_forward_circle_sharp, color: Colors.grey, size: 40)))),
            AnimatedPositioned(
                left: selected ? 10 : 0,
                top: selected ? 420 : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: GestureDetector(
                    onTap: () {
                      userContentProvider.changePageDown();
                    },
                    child: AnimatedOpacity(
                        opacity: selected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(Ionicons.arrow_back_circle_sharp, color: Colors.grey, size: 40)))),
          ])),
    );
  }

  Widget mobile() {
    return Container();
  }

  void pageDown() async {
    setState(() {
      selected = !selected;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    if (onePass) {
      print('one pass');
      setState(() {
        onePass = false;
      });
      Navigator.of(context).pop();
    }
  }

  String profileImageSearch(ContentProvider contentProvider, String userId) {
    String returnString = '';
    List ssd = contentProvider.profileImage;

    for (var element in ssd) {
      String userid5 = element['userId'];
      if (userId == userid5) {
        Map map = element['images'];
        String imgString = map.values.elementAt(5).toString();
        returnString = 'http://172.30.1.19:3000/view/$imgString';
        break;
      } else {
        returnString = '';
      }
    }
    if (returnString == '') {
      returnString = 'http://172.30.1.19:3000/view/basic.png';
    }
    return returnString;
  }
}
