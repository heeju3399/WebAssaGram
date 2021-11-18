import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/darktheme.dart';
import 'package:web/model/icons.dart';
import 'package:web/model/mywidget.dart';
import 'package:web/model/myword.dart';
import 'package:web/model/provider/getcontent.dart';
import 'package:web/model/provider/mousehover.dart';
import 'package:web/model/provider/setcontent.dart';
import 'package:web/model/shared.dart';
import 'package:web/page/dialog/dialog.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:web/responsive.dart';

class MainDash extends StatefulWidget {
  const MainDash({Key? key}) : super(key: key);

  @override
  _MainDashState createState() => _MainDashState();
}

// ignore_for_file: avoid_print
class _MainDashState extends State<MainDash> with SingleTickerProviderStateMixin {
  MyShared shared = MyShared();
  DateTime currentBackPressTime = DateTime.now();
  int pageFlag = 0;
  List<XFile> imagesList = [];
  List<bool> isMainIconsColor = [true, false, false, false];
  String userId = 'admin';
  int listViewCount = 5;

  List<Widget> widgetList = [];
  List<TextEditingController> textEditingController = [];
  List<bool> favoriteOnHover = [];
  List<bool> badOnHover = [];
  List<int> valueList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  //final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  bool mouseHover = false;
  final List<PageController> pageController2 = [];
  bool pageIsScrolling = false;
  int listViewLength = 0;

  ////comment///
  List<TextEditingController> textCommentEditingController = [];
  List<bool> autoFocus = [];
  List<FocusNode> myFocusNodeList = [];
  int commentIndex = 0;

  @override
  void initState() {
    super.initState();
    print('init');
  }

  @override
  void dispose() {
    print('main dash dispose pass');

    for (var element in myFocusNodeList) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build pass');
    //String userId = shared.userId.toString();
    String userId = 'admin';
    print('main Dash call userid : $userId');
    return WillPopScope(onWillPop: onWillPop, child: Responsive.isLarge(context) ? windowPage(context, userId) : mobilePage(context, userId));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Fluttertoast.showToast(msg: '종료 하시려면 한번더 터치해주세요');aaasdfasdf yhnujiklo89v
      return Future.value(false);
    }
    return Future.value(true);
  }

  ///////////////////////////////////////////////

  Widget mobilePage(BuildContext context, String userId) {
    bool checkLogin = false;
    print('???? : $userId');
    if (userId == MyWord.LOGIN) {
      checkLogin = true;
    }
    print('?? : $checkLogin');
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Mobile!'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////
  Widget mainContent(BuildContext context, String userId) {
    Widget result = const CircularProgressIndicator();
    if (pageFlag == 0) {
      result = homePage(context, userId);
    } else if (pageFlag == 1) {
      listViewCount = 5;
      result = addPage(context, userId);
    } else if (pageFlag == 2) {
      result = favoritePage(context, userId);
    } else if (pageFlag == 3) {
      result = profilePage(context, userId);
    }
    return result;
  }

  void pageChange(int flag) {
    pageFlag = flag;
    for (var i = 0; i < 4; i++) {
      if (flag == i) {
        isMainIconsColor[i] = true;
      } else {
        isMainIconsColor[i] = false;
      }
    }
    setState(() {});
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

  Widget windowPage(BuildContext context, String userId) {
    final mouseHoverToggle = Provider.of<MouseHoverToggle>(context);
    return Scaffold(
      backgroundColor: DisplayControl.mainAppColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        primary: true,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text('ASSA_GRAM', style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
        actions: [
          const SizedBox(width: 50),
          IconButton(
              onPressed: () => pageChange(0),
              icon: isMainIconsColor[0] ? const Icon(Icons.home_filled, color: Colors.red) : const Icon(Icons.home_outlined, color: Colors.black)),
          const SizedBox(width: 20),
          IconButton(
              onPressed: () => pageChange(1),
              icon: isMainIconsColor[1] ? const Icon(DIcons.add_circle, color: Colors.red) : const Icon(DIcons.add_circle, color: Colors.black)),
          const SizedBox(width: 20),
          IconButton(
              onPressed: () => pageChange(2),
              icon: isMainIconsColor[2] ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_border, color: Colors.black)),
          const SizedBox(width: 20),
          IconButton(
              onPressed: () => pageChange(3),
              icon: isMainIconsColor[3] ? const Icon(DIcons.sign_in, color: Colors.red) : const Icon(DIcons.sign_in, color: Colors.black)),
          const SizedBox(width: 100),
          //tab bar!!
        ],
      ),
      body: RawScrollbar(
          controller: _scrollController,
          thumbColor: Colors.white,
          isAlwaysShown: true,
          radius: const Radius.circular(20),
          thickness: 15,
          child: SingleChildScrollView(
              physics: mouseHoverToggle.save ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
              //physics: const ScrollPhysics(),
              child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(height: 30),
                SizedBox(width: 900, child: mainContent(context, userId)),
                const SizedBox(height: 30),
                Container(height: 100, color: DisplayControl.mainAppColor, alignment: Alignment.center, child: MyWidget.myTextWhite('Test Corp'))
              ])))),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      // ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget homePage(BuildContext context, String userId) {
    bool myIdCheck = false;
    if (userId == this.userId) {
      myIdCheck = true;
    }
    print('home page pass');
    final providerData = Provider.of<ContentProvider>(context);
    final mouseHoverToggle = Provider.of<MouseHoverToggle>(context);
    final contentDataList = providerData.contentDataModelList;
    print(contentDataList.length);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(width: 800, height: 130, color: Colors.grey),
        ), //아싸 베스트 프로필
        const Divider(),
        Container(
            width: 800,
            color: DisplayControl.mainAppColor,
            child: ListView.builder(
                itemCount: contentDataList.length,
                shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  listViewLength = contentDataList.length;
                  ContentDataModel contentData = contentDataList[index];
                  String date = contentData.createTime;
                  int contentId = contentData.contentId;
                  int imageListLength = contentData.images.length;
                  List<String> imagesUrlList = [];

                  for (var contentDataImages in contentData.images) {
                    //사진 url 편집
                    ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                    String fileName = imagesDataModel.filename;
                    String urlString = 'http://172.30.1.19:3000/view/$fileName';
                    imagesUrlList.add(urlString);
                  }

                  pageController2.add(PageController(initialPage: imageListLength, viewportFraction: 0.9)); // pageview 초기화및 몇개넣을지 정하기

                  try {
                    for (var element in contentData.comment) {
                      print(element);
                      CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
                      print(commentDataModel.createTime);

                      print(commentDataModel.userId);
                      print(commentDataModel.comment);
                      print(commentDataModel.commentSeq);

                      print('=============================');
                    }
                  } catch (e) {
                    print('err?????????????? $e');
                  }

                  textEditingController.add(TextEditingController());
                  textCommentEditingController.add(TextEditingController());
                  myFocusNodeList.add(FocusNode());

                  return Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(1)),
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
                                          onTap: () {},
                                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: DisplayControl.mainAppColor,
                                                    borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(40.0),
                                                        bottomRight: Radius.circular(40.0),
                                                        topLeft: Radius.circular(40.0),
                                                        bottomLeft: Radius.circular(40.0)))),
                                            Padding(
                                                padding: EdgeInsets.only(left: 18.0),
                                                child: Text(contentData.userId, style: const TextStyle(fontSize: 19)))
                                          ])))
                                ])),
                            const Divider(height: 1, color: Colors.black),
                            Container(
                              height: 500,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white)),
                              //////////////////////////////////////////////////////////////////////////////
                              child: MouseRegion(
                                onHover: (v) {
                                  if (!mouseHoverToggle.save) {
                                    //print('한번만 치기');
                                    mouseHoverToggle.boolTure();

                                  }
                                },
                                onExit: (v) {
                                  mouseHoverToggle.boolFalse();
                                },
                                child: Listener(
                                  onPointerSignal: (pointerSignal) {
                                    if (pointerSignal is PointerScrollEvent) {
                                      imagesPageScroll(pointerSignal.scrollDelta.dy, index);
                                    }
                                  },
                                  child: PageView.builder(
                                    controller: pageController2[index],
                                    itemCount: imageListLength,
                                    reverse: true,
                                    itemBuilder: (BuildContext context, int pageIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          imagesUrlList[pageIndex],
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              /////////////////////////////////////////////////////////////////////////////////
                            ), //사진!!
                            Container(
                              //color: Colors.black,
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
                                                        if (value == 'ok') {providerData.setLikeAndBad(0, index, contentData.likeCount)}
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
                                                        if (value == 'ok') {providerData.setLikeAndBad(1, index, contentData.badCount)}
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
                                  itemBuilder: (context, index) {
                                    commentIndex = index;
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
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(userId, style: const TextStyle(color: Colors.white, fontSize: 20)),

                                          SizedBox(
                                              width: 570,
                                              child: Text(commentString,
                                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip)),

                                          Text(agoDate, style: const TextStyle(color: Colors.white, fontSize: 20)),
                                          // myIdCheck
                                          //    ? IconButton(
                                          //    icon: const Icon(Icons.delete_forever, color: Colors.grey, size: 25),
                                          //    onPressed: () {
                                          //      //MainContentControl.deleteComment(contentId: item.contentId, userId: userId, order: order);
                                          //      //Body.of(context)!.setBool = false;
                                          //    })
                                          //    :  Text('$userId'),
                                        ]));
                                  }),
                              //)
                            ),
                            Container(
                                height: 60,
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white), color: Colors.black),
                                child: TextField(
                                    focusNode: myFocusNodeList[index],
                                    controller: textCommentEditingController[index],
                                    onSubmitted: (v) {
                                      if (v != '' && v.isNotEmpty) {
                                        if (userId != MyWord.LOGIN) {
                                          print('pass??');
                                          //providerData.setComment(userId: userId, comment: v, contentIndex: index);
                                           ContentControl.setComment(index: contentData.contentId, value: v, userId: userId).then((value) => {
                                             if (value) {providerData.setComment(userId: userId, comment: v, contentIndex: index)}
                                           });
                                          //Body.of(context)!.setBool = false;
                                          textCommentEditingController[index].clear();
                                          myFocusNodeList[index].requestFocus();
                                        } else {
                                          textCommentEditingController[index].clear();
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
                if (listViewLength % 5 == 0) {
                  print('덜나왔음');
                  providerData.getContent();
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

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  TextEditingController textFiledTitleController = TextEditingController();
  int imagesFullCount = 0;

  Widget addPage(BuildContext context, String userId) {
    return Column(
      children: [
        SizedBox(
            width: 700,
            height: 100,
            child: TextField(
                controller: textFiledTitleController,
                style: const TextStyle(fontSize: 25, color: Colors.white),
                decoration: const InputDecoration(
                    labelText: '제목',
                    labelStyle: TextStyle(fontSize: 25, color: Colors.white),
                    suffixStyle: TextStyle(fontSize: 25, color: Colors.white),
                    hintStyle: TextStyle(fontSize: 25, color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))))), //제목

        //////////////// add picture ////////////////////////
        const SizedBox(height: 30),
        Consumer<SetContentProvider>(builder: (context, provider, child) {
          print('provider build pass!!');
          //var ss = provider.images!.length;
          print(provider.images);
          print('---------------------------------------');
          if (imagesList.isNotEmpty) {
            return SizedBox(
              width: 700,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: imagesList.length, //item 개수
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    //childAspectRatio: 1 / 2, //item 의 가로 1, 세로 2 의 비율
                    // mainAxisSpacing: 10, //수평 Padding
                    // crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    print('grid build pass!! ');
                    XFile imgFile = imagesList.elementAt(index);
                    print('***********************************!! ${imgFile.path}');
                    //item 의 반목문 항목 형성
                    return InkWell(
                      onLongPress: () {
                        print('pass : $index');
                        setState(() {
                          imagesList.removeAt(index);
                          imagesFullCount--;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(imgFile.path),
//               //Image.network(provider.image.path),
//               //if (provider.images != null)
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 100,
                child: Text('길게 누르면 지워집니다.', textScaleFactor: 2, style: TextStyle(color: Colors.white)),
              ),
            );
          }
        }),
        // 사진란// 사진란// 사진란// 사진란// 사진란// 사진란// 사진란// 사진란
        const SizedBox(height: 50),
        Consumer<SetContentProvider>(builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    addImages();
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  child: Container(
                      width: 150,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Text('사진추가', style: TextStyle(fontSize: 20)))),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      imagesList.clear();
                      imagesFullCount = 0;
                    });
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: Container(
                      width: 150,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Text('전체삭제', style: TextStyle(fontSize: 20)))),
              ElevatedButton(
                  onPressed: () {
                    callSetContentControl();
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Container(
                      width: 150,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Text('저장', style: TextStyle(fontSize: 20)))),
            ],
          );
        }),
        const SizedBox(height: 50),
        //사진 추가 버튼
      ],
    );
  }

  void callSetContentControl() async {
    Map result = await ContentControl.setContent(title: textFiledTitleController.text, userId: userId, images: imagesList);
    if (result.values.elementAt(0) == 'pass') {
      MyDialog.setContentDialog(title: result.values.elementAt(0), message: result.values.elementAt(1), context: context);
      imagesList.clear();
      pageChange(0);
    }
  }

  void addImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(imageQuality: 500, maxHeight: 500, maxWidth: 500);
    bool imagesFull = false;
    for (var element in images!) {
      if (imagesFullCount < 6) {
        imagesList.add(element);
        imagesFullCount++;
      } else {
        imagesFull = true;
      }
    }
    if (imagesFull) {
      MyDialog.setContentDialog(title: '초과', message: '최대 6개만 등록해주세요!', context: context);
    }
    setState(() {});
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget favoritePage(BuildContext context, String userId) {
    return Container(
      width: 1000,
      height: 500,
      color: Colors.orange,
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget profilePage(BuildContext context, String userId) {
    return Container(
      width: 500,
      height: 1000,
      color: Colors.blue,
    );
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
