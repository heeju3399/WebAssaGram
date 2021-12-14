import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/rankerprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/icons.dart';
import '../../responsive.dart';

class RankerDetailPage extends StatefulWidget {
  const RankerDetailPage({Key? key}) : super(key: key);

  @override
  _RankerDetailPageState createState() => _RankerDetailPageState();
}

class _RankerDetailPageState extends State<RankerDetailPage> {
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
    RankerProvider rankerProvider = Provider.of<RankerProvider>(context);
    return Responsive.isLarge(context) ? windows(rankerProvider) : mobile();
  }

  PageController pageController2 = PageController();
  int imagesPage = 0;

  Widget images(ContentDataModel contentData) {
    List imagecontent = contentData.images; //하나의 콘텐트 안에 이미지 겟수
    List urlList = [];
    for (var element in imagecontent) {
      ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(element);
      String fileName = imagesDataModel.filename;
      String urlString = 'http://172.30.1.19:3000/view/$fileName';
      urlList.add(urlString);
    }

    return PageView.builder(
      itemCount: imagecontent.length,
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

  Widget commentListView(ContentDataModel contentData) {
    return ListView.builder(
        itemCount: contentData.comment.length,
        //itemCount: 10,
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
                    offset: Offset(4, 8),
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
                          style: TextStyle(color: Colors.lightGreenAccent),
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

  Widget windows(RankerProvider rankerProvider) {
    List contentDataList = rankerProvider.rankerDetailContentList;
    int index = rankerProvider.detailIndex;
    ContentDataModel contentData = contentDataList[index];
    List profileImageList = rankerProvider.profileImageListStringUri;
    String profileImageUri = profileImageList[index];

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
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
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
                                        child: const Icon(Ionicons.arrow_back_circle_sharp, color: Colors.grey, size: 40)))),
                          ],
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                                ),
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
                                            const SizedBox(width: 10),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(profileImageUri),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                contentData.userId,
                                                textScaleFactor: 2,
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Container(),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 10,
                            ),
                            Divider(
                              height: 1,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: commentListView(contentData),
                              ),
                              flex: 70,
                            ),
                            /////////////////////////// 33333333333333/ /////////////////////////
                            //const Expanded(flex: 1, child: Divider()),
                            Divider(
                              height: 1,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Row(children: [
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        const Flexible(child: Icon(Icons.favorite_border)),
                                        Flexible(child: Text('( ${contentData.likeCount} )'))
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
                                    flex: 1,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Flexible(child: Icon(DIcons.remove_red_eye)),
                                        Flexible(child: Text('( ${contentData.viewCount} )')),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                  //Flexible(flex: 1,child: Container()),
                                ]),
                              ),
                              flex: 10,
                            ),
                            Divider(
                              height: 1,
                            ),
                          ],
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                //////////////// all page view //////////////////////////////
              ),
            ),
            AnimatedPositioned(
                right: selected ? 20 : 0,
                top: selected ? 20 : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: GestureDetector(
                    onTap: () {
                      print('?????????');
                      pagedown();
                    },
                    child: AnimatedOpacity(
                        opacity: selected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(Icons.cancel, color: Colors.red, size: 60))))
          ])),
    );
  }

  Widget mobile() {
    return Container();
  }

  void pagedown() async {
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
}
