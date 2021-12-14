import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/rankerprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/darktheme.dart';
import 'package:web/model/icons.dart';
import 'package:web/model/myword.dart';

import 'dialog/dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TextEditingController> textCommentEditingController = [];
  List<bool> autoFocus = [];
  List<FocusNode> myFocusNodeList = [];
  String errIdText = '';
  String errPassText = '';
  double downCountPlus = 1.0;
  List<TextEditingController> textEditingController = [];
  final List<PageController> pageController2 = [];
  bool pageIsScrolling = false;
  int listViewLength = 0;
  bool myIdCheck = false;
  bool isProfileImage = false;

  @override
  Widget build(BuildContext context) {
    UserProvider loginProvider = Provider.of<UserProvider>(context);
    String getProviderUserId = loginProvider.userId.toString();

    return homePage(context, getProviderUserId, loginProvider);
  }

  String redefine(ContentProvider contentProvider, ContentDataModel contentData) {
    String returnProfileString = 'http://172.30.1.19:3000/view/basic.png';
    //리스트뷰에서 온 아이디를 참고로 재 정의 해서 주면 되자나?
    // 하나의 컨텐트 아이디와 프사의 컨텐트 아이디가 맞을 경우 그아이디의 프사 스트링을 전송
    String imgString = '';
    List profileImageList = contentProvider.profileImage;
    for (var element in profileImageList) {
      //print(element);
      String userid5 = element['userId'];
      if (contentData.userId == userid5) {
        //print('맞다?');
        Map map = element['images'];
        imgString = map.values.elementAt(5).toString();
        returnProfileString = 'http://172.30.1.19:3000/view/$imgString';
        break;
      } else {
        //print('아니다!!');
        returnProfileString = 'http://172.30.1.19:3000/view/basic.png';
      }
    }
    return returnProfileString;
  }

  Widget homePage(BuildContext context, String userId, UserProvider userProvider) {
    print('home page pass $userId');
    final contentProvider = Provider.of<ContentProvider>(context);
    final homepageProvider = Provider.of<HomePageProvider>(context);
    final contentDataList = contentProvider.contentDataModelList;
    userProvider.setProfileImagesList(contentProvider.profileImage);

    return Column(
      children: [
        Padding(padding: EdgeInsets.all(20)),
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Container(
        //     width: 800,
        //     height: 100,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.white),
        //     ),
        //     child: ListView.builder(
        //         itemCount: 6,
        //         scrollDirection: Axis.horizontal,
        //         shrinkWrap: true,
        //         itemBuilder: (context, index2) {
        //       return Padding(
        //         padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
        //         child: InkWell(
        //           onTap: (){
        //
        //           },
        //           child: Container(
        //               width: 80,
        //               height: 80,
        //               decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   image: DecorationImage(fit: BoxFit.fill, image: NetworkImage('http://172.30.1.19:3000/view/basic.png')))),
        //         ),
        //       );
        //     }),
        //   ),
        // ), //아싸 베스트 프로필
        const Divider(),
        Container(
            width: 800,
            color: DisplayControl.mainAppColor,
            child: ListView.builder(
                itemCount: contentDataList.length,
                shrinkWrap: true,
                itemBuilder: (context, contentIndex) {
                  listViewLength = contentDataList.length;
                  ContentDataModel contentData = contentDataList[contentIndex];
                  String date = contentData.createTime;
                  int contentId = contentData.contentId;
                  int imageListLength = contentData.images.length;
                  List<String> imagesUrlList = [];

                  String profileImageUri = '';
                  profileImageUri = redefine(contentProvider, contentData);
                  for (var contentDataImages in contentData.images) {
                    //사진 url 편집
                    ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                    String fileName = imagesDataModel.filename;
                    String urlString = 'http://172.30.1.19:3000/view/$fileName';
                    imagesUrlList.add(urlString);
                  }
                  List<String> reversList = imagesUrlList.reversed.toList();
                  imagesUrlList = reversList;
                  pageController2.add(PageController(initialPage: imageListLength, viewportFraction: 0.9)); // pageview 초기화및 몇개넣을지 정하기
                  textEditingController.add(TextEditingController());
                  textCommentEditingController.add(TextEditingController());
                  myFocusNodeList.add(FocusNode());

                  return Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(1)),
                            border: Border.all(
                              width: 1,
                              color: DisplayControl.mainAppColor,
                            ),
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            SizedBox(
                                height: 65,
                                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: InkWell(
                                        onTap: () {
                                          print('profiel pass');
                                          print('profiel pass ${contentData.userId}');
                                          print('profiel pass $contentId');
                                          userProvider.setDifProfileImageStringUri(profileImageUri);
                                          homepageProvider.pageChange(9);
                                          userProvider.setContentId(contentData.userId);
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                          Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(profileImageUri)))),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 18.0),
                                              child: Text(contentData.nicName, style: const TextStyle(fontSize: 19)))
                                        ]),
                                      ))
                                ])),
                            const Divider(height: 1, color: Colors.black),
                            Container(
                              height: 500,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white)),
                              child: MouseRegion(
                                onHover: (v) {
                                  if (!homepageProvider.save) {
                                    homepageProvider.boolTure();
                                  }
                                },
                                onExit: (v) {
                                  homepageProvider.boolFalse();
                                },
                                child: Listener(
                                  onPointerSignal: (pointerSignal) {
                                    if (pointerSignal is PointerScrollEvent) {
                                      imagesPageScroll(pointerSignal.scrollDelta.dy, contentIndex);
                                    }
                                  },
                                  child: PageView.builder(
                                    controller: pageController2[contentIndex],
                                    itemCount: imageListLength,
                                    reverse: true,
                                    itemBuilder: (BuildContext context, int pageIndex) {
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(imagesUrlList[pageIndex], fit: BoxFit.fill, alignment: Alignment.center));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white), color: Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        IconButton(
                                            onPressed: () {
                                              print('favo pass');
                                              ContentControl.setLikeAndBad(flag: 0, contentId: contentId, likeAndBad: contentData.likeCount)
                                                  .then((value) => {
                                                        if (value == 'ok') {contentProvider.setLikeAndBad(0, contentIndex, contentData.likeCount)}
                                                      });
                                            },
                                            icon: const Icon(DIcons.favorite),
                                            iconSize: 25,
                                            color: Colors.white),
                                        RichText(text: TextSpan(text: '${contentData.likeCount}', style: TextStyle(color: Colors.white))),
                                        const SizedBox(width: 25),
                                        IconButton(
                                            onPressed: () {
                                              print('bad pass');
                                              ContentControl.setLikeAndBad(flag: 1, contentId: contentId, likeAndBad: contentData.badCount)
                                                  .then((value) => {
                                                        if (value == 'ok') {contentProvider.setLikeAndBad(1, contentIndex, contentData.badCount)}
                                                      });
                                            },
                                            icon: const Icon(DIcons.emo_unhappy),
                                            iconSize: 25,
                                            color: Colors.white),
                                        RichText(text: TextSpan(text: '${contentData.badCount}', style: TextStyle(color: Colors.white))),
                                        const SizedBox(width: 25),
                                        IconButton(
                                            mouseCursor: SystemMouseCursors.basic,
                                            onPressed: () {},
                                            icon: const Icon(DIcons.remove_red_eye),
                                            iconSize: 25,
                                            color: Colors.white),
                                        RichText(text: TextSpan(text: '${contentData.viewCount}', style: TextStyle(color: Colors.white))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RichText(text: TextSpan(text: ContentControl.contentTimeStamp(date), style: TextStyle(color: Colors.white))),
                                        const SizedBox(width: 20),
                                      ],
                                    )
                                    //좋아요 싫어요 뷰수 넣기!! 생성날짜는 몇일전 이렇게 !!
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 800,
                              height: 230,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white), color: Colors.black),
                              child: ListView.builder(
                                  itemCount: contentData.comment.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, commentIndex) {
                                    Map element = contentData.comment[commentIndex];
                                    CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
                                    String agoDate = ContentControl.contentTimeStamp(commentDataModel.createTime);
                                    //myIdCheck
                                    if(userId == commentDataModel.userId){
                                      myIdCheck = false;
                                    }else{
                                      myIdCheck = true;
                                    }
                                    List<dynamic> utf8List2 = jsonDecode(commentDataModel.comment);
                                    List<int> intList = [];
                                    for (var element in utf8List2) {
                                      intList.add(element);
                                    }
                                    String commentString = utf8.decode(intList);
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(commentDataModel.userId, style: const TextStyle(color: Colors.white, fontSize: 20)),
                                          SizedBox(
                                              width: 570,
                                              child: Text(commentString,
                                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip)),
                                          myIdCheck
                                              ? Text(agoDate, style: const TextStyle(color: Colors.white, fontSize: 20))
                                              : TextButton(
                                                  onPressed: () {
                                                    contentProvider.deleteComment(
                                                        contentId, userId, commentDataModel.commentSeq, commentIndex, contentIndex);
                                                  },
                                                  child: const Text('지우기', style: TextStyle(color: Colors.red, fontSize: 20))),
                                        ]));
                                  }),
                              //)
                            ),
                            Container(
                                height: 60,
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white), color: Colors.black),
                                child: TextField(
                                    focusNode: myFocusNodeList[contentIndex],
                                    controller: textCommentEditingController[contentIndex],
                                    onSubmitted: (v) {
                                      if (v != '' && v.isNotEmpty) {
                                        if (userId != MyWord.LOGIN) {
                                          contentProvider.setComment(
                                              contentIndex: contentData.contentId, comment: v, userId: userId, pageListIndex: contentIndex);
                                          textCommentEditingController[contentIndex].clear();
                                          myFocusNodeList[contentIndex].requestFocus();
                                        } else {
                                          textCommentEditingController[contentIndex].clear();
                                          MyDialog.setContentDialog(title: '접속불가', message: '로그인 부탁드려요', context: context);
                                        }
                                      }
                                    },
                                    style: const TextStyle(fontSize: 20, color: Colors.white),
                                    decoration: const InputDecoration(
                                        hintText: '입력 후 엔터',
                                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(1.0)),
                                            borderSide: BorderSide(width: 1, color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(1.0)),
                                            borderSide: BorderSide(width: 1, color: Colors.white)),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(1.0)))))) //댓글삽입창
                          ])));
                })),
        Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: TextButton(
              onPressed: () {
                downCountPlus = downCountPlus + 1.0;
                print('listViewLength $listViewLength');
                if (listViewLength % 5 == 0) {
                  print('덜나왔음');
                  contentProvider.getContent();
                  homepageProvider.setDownCountPlus();
                } else {
                  print('다나왔음!!');
                  MyDialog.setContentDialog(title: 'LAST', message: '글작성 부탁드려요', context: context);
                }
              },
              child: const Text('더보기',
                  style: TextStyle(color: Colors.white),
                  textScaleFactor:
                      2), //Container(width: 500,height: 200,child: Text('5개 더보기....아',style: TextStyle(color: Colors.white),textScaleFactor: 3,),),
            )) //아싸 베스트
      ],
    );
  }

  void imagesPageScroll(double offset, int index) {
    //print(offset);
    if (pageIsScrolling == false) {
      pageIsScrolling = true;
      if (offset > 0) {
        pageController2[index]
            .previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
            .then((value) => pageIsScrolling = false);
        print('scroll down');
      } else {
        pageController2[index]
            .nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
            .then((value) => pageIsScrolling = false);
        print('scroll up');
      }
    }
  }
}
