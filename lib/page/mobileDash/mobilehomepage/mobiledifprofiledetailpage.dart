// import 'dart:html';
//
// import 'package:flutter/material.dart';
//
// class DifProfileDetailPage extends StatelessWidget {
//   const DifProfileDetailPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('게시물'),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/icons.dart';
import 'package:web/model/myword.dart';
import 'mobilecommentpage.dart';
import 'mobiledifprofilepage.dart';
import 'mobileusercommentpage.dart';

class DifProfileDetailPage extends StatefulWidget {
  const DifProfileDetailPage({Key? key}) : super(key: key);

  @override
  _DifProfileDetailPageState createState() => _DifProfileDetailPageState();
}

class _DifProfileDetailPageState extends State<DifProfileDetailPage> {
  PageController mainPageController = PageController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int mainLastPageCount = 1;
  List<TextEditingController> textCommentEditingController = [];
  List<FocusNode> myFocusNodeList = [];
  final List<PageController> imagesPageController = [];
  bool pageIsScrolling = false;
  int listViewLength = 0;

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    //userContentProvider.userContentDataList;
    int page = userContentProvider.contentPageIndex;
    //mainPageController.jumpToPage(page);
    print('0000');

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      mainPageController.animateToPage(page, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    });
    print('2222');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('게시물'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: _refresh,
          child: PageView.builder(
              controller: mainPageController,
              itemCount: userContentProvider.userContentDataList.length,
              scrollDirection: Axis.vertical,
              // onPageChanged: (v) {
              //   if (mainLastPageCount == v) {
              //     mainLastPageCount++;
              //     print('같음...');
              //     if (v % 4 == 0) {
              //       print('호출!!');
              //       userContentProvider.getContent();
              //     }
              //   } else {
              //     print('다름...');
              //   }
              //   print('v?? $v ///// mainLastPageCount?? $mainLastPageCount');
              // },
              itemBuilder: (context, contentIndex) {
                ContentDataModel contentData = userContentProvider.userContentDataList[contentIndex];
                String date = contentData.createTime;
                int contentId = contentData.contentId;
                int imageListLength = contentData.images.length;
                List<String> imagesUrlList = [];
                String profileImageUri = '';
                profileImageUri = userContentProvider.userProfileImageUri;
                for (var contentDataImages in contentData.images) {
                  ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                  String fileName = imagesDataModel.filename;
                  String urlString = MyWord.imagesServerIpAndPort + fileName;
                  imagesUrlList.add(urlString);
                }
                List<String> reversList = imagesUrlList.reversed.toList();
                imagesUrlList = reversList;
                imagesPageController.add(PageController()); // pageview 초기화및 몇개넣을지 정하기
                textCommentEditingController.add(TextEditingController());
                myFocusNodeList.add(FocusNode());

                //comment//
                Map element = contentData.comment[0];
                CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
                String agoDate = ContentControl.contentTimeStamp(commentDataModel.createTime);
                List<dynamic> utf8List2 = jsonDecode(commentDataModel.comment);
                List<int> intList = [];
                for (var element in utf8List2) {
                  intList.add(element);
                }
                String commentString = utf8.decode(intList);

                return Container(
                  child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                const SizedBox(width: 10),
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(profileImageUri)))),
                                Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(contentData.nicName, style: const TextStyle(fontSize: 19)))
                              ])),
                          Expanded(
                              child: PageView.builder(
                                controller: imagesPageController[contentIndex],
                                itemCount: imageListLength,
                                itemBuilder: (BuildContext context, int pageIndex) {
                                  return Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.network(imagesUrlList[pageIndex], fit: BoxFit.fill, alignment: Alignment.center));
                                },
                              ),
                              flex: 8),
                          Expanded(
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Flexible(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 5),
                                      Flexible(child: IconButton(onPressed: () {
                                        ContentControl.setLikeAndBad(flag: 0, contentId: contentId, likeAndBad: contentData.likeCount)
                                            .then((value) => {
                                          if (value == 'ok') {contentProvider.setLikeAndBad(0, contentIndex, contentData.likeCount)}
                                        });
                                      }, icon: Icon(DIcons.favorite, color: Colors.redAccent)), flex: 1),
                                      const SizedBox(width: 10),
                                      Flexible(child: IconButton(onPressed: () {
                                        ContentControl.setLikeAndBad(flag: 1, contentId: contentId, likeAndBad: contentData.badCount)
                                            .then((value) => {
                                          if (value == 'ok') {contentProvider.setLikeAndBad(1, contentIndex, contentData.badCount)}
                                        });
                                      }
                                      , icon: const Icon(DIcons.emo_angry, color: Colors.black)), flex: 1),
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Flexible(
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      Flexible(
                                          flex: 1,
                                          child: Container(
                                              color: Colors.white.withOpacity(0.5),
                                              padding: const EdgeInsets.all(5.0),
                                              child: Center(
                                                  child: DotsIndicator(
                                                      controller: imagesPageController[contentIndex],
                                                      itemCount: imageListLength,
                                                      onPageSelected: (int page) {
                                                        imagesPageController[contentIndex]
                                                            .animateToPage(page, duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                                      })))),
                                    ]),
                                    flex: 1),
                                Flexible(child: Row(children: []), flex: 1),
                              ]),
                              flex: 1),
                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white), color: Colors.black),
                                child: ListView.builder(
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
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(commentDataModel.userId,
                                                maxLines: 1, overflow: TextOverflow.clip, style: const TextStyle(color: Colors.white, fontSize: 15)),
                                            SizedBox(
                                                child: Text(commentString,
                                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip)),
                                            Text(agoDate, style: const TextStyle(color: Colors.white, fontSize: 15))
                                          ]));
                                    }),
                                //)
                              ),
                              flex: 4),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      print('page index $contentIndex');
                                      userContentProvider.setUserContent(contentIndex);
                                      userContentProvider.setPage(contentIndex);
                                      ContentControl.navigatorPush(context, const MobileUserCommentPage());
                                    },
                                    child: Text('댓 글 란', textScaleFactor: 1),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.black),
                                        fixedSize: MaterialStateProperty.all(Size.fromWidth(1000)))),
                              ),
                              flex: 1),
                        ],
                      )),
                );
              }),
        ),
      ),
    );
  }

  void delayed(int second) async {
    Future.delayed(const Duration(seconds: 1)).then((value) => {});
  }
}

class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
  }) : super(key: key, listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 18.0;

  Widget _buildDot(int index) {
    Color color = Colors.grey;
    var choseIndex = controller.page;
    if (choseIndex != null) {
      int choseIndex2 = choseIndex.round();
      if (index == choseIndex2) {
        color = Colors.blueAccent;
      }
    }
    double kiosk = Curves.easeOut.transform(
      max(
        0.0,
        0.2 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * kiosk;
    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: SizedBox(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(onTap: () => onPageSelected(index)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
