import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/dotindicator.dart';
import 'package:web/model/icons.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/mobileDash/mobilehomepage/mobileaddimagespage.dart';
import 'mobilecommentpage.dart';
import 'mobiledifprofilepage.dart';
import 'mobileloginpage.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  _MobileHomePageState createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  List<TextEditingController> textCommentEditingController = [];
  final List<PageController> imagesPageController = [];
  PageController mainPageController = PageController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<FocusNode> myFocusNodeList = [];
  bool pageIsScrolling = false;
  int mainLastPageCount = 1;
  int listViewLength = 0;
  bool myIdCheck = false;
  bool init = true;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    if (init) {
      contentProvider.initGetContent();
      init = false;
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('ASSA_GRAM'),
        actions: [
          if (userProvider.userId == MyWord.LOGIN) IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileSignPage()));
          }, icon: const Icon(Ionicons.log_in_outline), color: Colors.white),
          if (userProvider.userId != MyWord.LOGIN) IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileAddImagesPage()));
          }, icon: const Icon(Icons.add_circle), color: Colors.white),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: _refresh,
          child: PageView.builder(
              controller: mainPageController,
              itemCount: contentProvider.contentDataModelList.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (v) {
                if (mainLastPageCount == v) {
                  mainLastPageCount++;
                  if (v % 4 == 0) {
                    contentProvider.getContent();
                  }
                }
              },
              itemBuilder: (context, contentIndex) {
                ContentDataModel contentData = contentProvider.contentDataModelList[contentIndex];
                int contentId = contentData.contentId;
                int imageListLength = contentData.images.length;
                List<String> imagesUrlList = [];
                String profileImageUri = '';
                profileImageUri = ContentControl.redefine(contentProvider, contentData);
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
                List<dynamic> utf8List2 = jsonDecode(commentDataModel.comment);
                List<int> intList = [];
                for (var element in utf8List2) {
                  intList.add(element);
                }

                return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                userProvider.setDifProfileImageStringUri(profileImageUri);
                                userProvider.setDifChooseContentUserId(contentData.userId);
                                ContentControl.navigatorPush(context, const MobileDifProfilePage());
                              },
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
                              ]),
                            )),
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
                                    }, icon: const Icon(DIcons.favorite, color: Colors.redAccent)), flex: 1),
                                    const SizedBox(width: 10),
                                    Flexible(child: IconButton(onPressed: () {
                                      ContentControl.setLikeAndBad(flag: 1, contentId: contentId, likeAndBad: contentData.badCount)
                                          .then((value) => {
                                        if (value == 'ok') {contentProvider.setLikeAndBad(1, contentIndex, contentData.badCount)}
                                      });
                                    }, icon: const Icon(DIcons.emo_angry, color: Colors.black)), flex: 1),
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
                              Flexible(child: Row(), flex: 1),
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(commentDataModel.userId,
                                              maxLines: 1, overflow: TextOverflow.clip, style: const TextStyle(color: Colors.white, fontSize: 15)),
                                          SizedBox(
                                              child: Text(commentString,
                                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip)),
                                          myIdCheck
                                              ? Text(agoDate, style: const TextStyle(color: Colors.white, fontSize: 15))
                                              : InkWell(
                                                  onTap: () {
                                                    contentProvider.deleteComment(
                                                        contentId, userProvider.userId, commentDataModel.commentSeq, commentIndex, contentIndex);
                                                  },
                                                  child: const Text('지우기', style: TextStyle(color: Colors.red, fontSize: 15))),
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
                                    contentProvider.setChooseContent(contentIndex);
                                    ContentControl.navigatorPush(context, const MobileDifCommentPage());
                                  },
                                  child: const Text('댓 글 란', textScaleFactor: 1),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.black),
                                      fixedSize: MaterialStateProperty.all(const Size.fromWidth(1000)))),
                            ),
                            flex: 1),
                      ],
                    ));
              }),
        ),
      ),
    );
  }
}
