import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/page/user/detailpageeeeeeeeeeeeeeeee.dart';

class DifProfilePage extends StatefulWidget {
  const DifProfilePage({Key? key}) : super(key: key);

  @override
  _DifProfilePageState createState() => _DifProfilePageState();
}

class _DifProfilePageState extends State<DifProfilePage> {
  bool reload = true;
  int contentId2 = 0;
  int listViewLength = 0;
  bool init = true;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    HomePageProvider homePageProvider = Provider.of<HomePageProvider>(context);
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    if (init) {
      userContentProvider.initGetContent(userProvider.contentId);
      init = false;
      setState(() {});
    }

    return Container(
        child:
            //Responsive.isLarge(context) ?
            windows(userProvider, homePageProvider, userContentProvider, contentProvider)
        //: mobile(userProvider, homePageProvider)
        );
  }

  // Center mobile(UserProvider userProvider, HomePageProvider homePageProvider) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
  //           Padding(
  //               padding: const EdgeInsets.only(top: 10),
  //               child: Text('${userProvider.userId} 님의 글',
  //                   maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontSize: 15, color: Colors.white))),
  //           const Padding(
  //               padding: EdgeInsets.only(top: 10),
  //               child: Text('길게 누르면 지워집니다', maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontSize: 15, color: Colors.white))),
  //           Padding(
  //               padding: const EdgeInsets.only(top: 10),
  //               child: Container(
  //                   decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //                   child: TextButton(
  //                       onPressed: () {
  //                         userProvider.logOut();
  //                         homePageProvider.pageChange(0);
  //                       },
  //                       child: Container(
  //                           width: 130,
  //                           height: 40,
  //                           alignment: Alignment.center,
  //                           child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //                             Icon(
  //                               Icons.logout,
  //                               color: Colors.white,
  //                             ),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                             Text('로그아웃', style: TextStyle(color: Colors.white))
  //                           ])))))
  //         ]),
  //         Padding(
  //             padding: const EdgeInsets.only(top: 10),
  //             child: Container(
  //               width: 500,
  //             )),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Container(
  //                   width: 200,
  //                   height: 40,
  //                   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
  //                   child: TextButton(
  //                       onPressed: () {
  //                         //contentAllDelete(contentId2);
  //                       },
  //                       child: Text('전체삭제', textScaleFactor: 2, style: TextStyle(color: Colors.white)))),
  //             ),
  //             Padding(
  //                 padding: const EdgeInsets.all(18.0),
  //                 child: Container(
  //                     width: 200,
  //                     height: 40,
  //                     decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
  //                     child: TextButton(
  //                         onPressed: () {
  //                           //userDelete();
  //                         },
  //                         child: Text('회원탈퇴', textScaleFactor: 2, style: TextStyle(color: Colors.white)))))
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Center windows(
      UserProvider userProvider, HomePageProvider homePageProvider, UserContentProvider userContentProvider, ContentProvider contentProvider) {

    String profileImage = '';
    profileImage = userProvider.difProfileImageString;
    //print('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB $profileImage');


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 700,
            height: 300,
            //color: Colors.black,
            decoration: const BoxDecoration(
              color: Colors.black,
              // border: Border.all(
              //   width: 1,
              //   color: Colors.white,
              // ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (profileImage == '')
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 190.0,
                          height: 190.0,
                          child: const Icon(
                            Ionicons.person_add_outline,
                            color: Colors.white,
                            size: 80,
                          ))),
                if (profileImage != '')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 190.0,
                        height: 190.0,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(profileImage)))),
                  ),
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text(userProvider.contentId, style: const TextStyle(color: Colors.white, fontSize: 20))),
                      DataColumn(
                          label: InkWell(
                        onTap: () {},
                        child: const Text(''),
                      )),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('게시물 (${userContentProvider.contentCount})', style: TextStyle(color: Colors.white, fontSize: 20))),
                          DataCell(Text('조회수 (${userContentProvider.viewCount})', style: TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('좋아요 (${userContentProvider.likeCount})', style: TextStyle(color: Colors.white, fontSize: 20))),
                          DataCell(Text('댓글수 (${userContentProvider.commentCount})', style: TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('시러요 (${userContentProvider.badCount})', style: TextStyle(color: Colors.white, fontSize: 20))),
                          DataCell(Text('', style: TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 750,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: userContentProvider.userContentDataList.length, //item 개수
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    //childAspectRatio: 0.6, //item 의 가로 1, 세로 2 의 비율
                    // mainAxisSpacing: 10, //수평 Padding
                    // crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    List userContentList = userContentProvider.userContentDataList;
                    listViewLength = userContentList.length;
                    ContentDataModel contentData = userContentList[index];
                    String date = contentData.createTime;
                    int contentId = contentData.contentId;
                    int imageListLength = contentData.images.length;
                    print('-----------------CONTENT DATA LEN $imageListLength) ================ ');
                    List<String> imagesUrlList = [];
                    List<String> imageName = [];

                    for (var contentDataImages in contentData.images) {
                      //사진 url 편집
                      ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                      String fileName = imagesDataModel.filename;
                      print('name?? ${imagesDataModel.filename}');
                      print('name?? ${imagesDataModel.originalName}');
                      print('name?? ${imagesDataModel.destination}');
                      String urlString = 'http://172.30.1.19:3000/view/$fileName';
                      imagesUrlList.add(urlString);
                    }
                    //imagesUrlList.reversed;
                    int gridviewcount = 1;
                    if (imageListLength == 1) {
                      gridviewcount = 1;
                    } else if (imageListLength == 2) {
                      gridviewcount = 2;
                    } else if (imageListLength >= 3) {
                      gridviewcount = 3;
                    }
                    print('??????????? $gridviewcount');

                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            print('몇번째일까? $index');
                            //detail page////detail page////detail page//
                            userContentProvider.setPage(index);
                            navigatorPush(context, const DetailPageeeeeeeeeeeee());
                            //detail page////detail page////detail page//
                          },
                          onLongPress: () {
                            //_showDeleteAlert(userContentProvider, contentProvider, index, userProvider.userId, contentData.content, contentId);
                          },
                          //child: Image.network(imagesUrlList[0], width: 300, height: 300),
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(imagesUrlList[0])))),
//               //Image.network(provider.image.path),
//               //if (provider.images != null)
                        ),
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  void navigatorPush(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _showDeleteAlert(
      UserContentProvider userContentProvider, ContentProvider contentProvider, int index, String userId, String content, int contentId) {
    List<dynamic> utf8List2 = jsonDecode(content);
    List<int> intList = [];
    for (var element in utf8List2) {
      intList.add(element);
    }
    String consentString = utf8.decode(intList);

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('삭제하시겠습니까?'),
            content: Text('제목 : $consentString'),
            insetAnimationCurve: Curves.decelerate,
            insetAnimationDuration: const Duration(seconds: 1),
            actions: [
              CupertinoButton(
                child: const Text('게시물 전체 삭제', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  print('전체 삭제 패쓰');
                  userContentProvider.deleteAllContent(userId).then((value) {
                    if (value) {
                      contentProvider.deleteUserAllContent(userId);
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              CupertinoButton(
                  child: const Text('게시물 삭제', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    userContentProvider.deleteContent(index, userId, contentId);
                    contentProvider.deleteUserContent(contentId);
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                  child: const Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  void _showSettingAlert(ContentProvider contentProvider, String title, UserProvider userProvider, HomePageProvider homePageProvider,
      UserContentProvider userContentProvider) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            insetAnimationCurve: Curves.decelerate,
            insetAnimationDuration: const Duration(seconds: 1),
            actions: [
              CupertinoButton(
                  child: const Text('로그아웃'),
                  onPressed: () {
                    userProvider.logOut();
                    homePageProvider.pageChange(0);
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('게시물 전체 삭제', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    print('전체 삭제 패쓰');
                    userContentProvider.deleteAllContent(userProvider.userId).then((value) {
                      if (value) {
                        contentProvider.deleteUserAllContent(userProvider.userId);
                        Navigator.pop(context);
                      }
                    });
                  }),
              CupertinoButton(
                  child: const Text('회원 탈퇴', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    userProvider.userWithdrawal(userProvider.userId).then((value) {
                      if (value) {
                        contentProvider.deleteUserAllContent(userProvider.userId);
                        userContentProvider.deleteAllContent(userProvider.userId);
                        userProvider.logOut();
                        Navigator.pop(context);
                        homePageProvider.pageChange(0);
                      }
                    });
                  }),
              CupertinoButton(child: const Text('게시물 1개 삭제는 롱 클릭'), onPressed: () {}),
              CupertinoDialogAction(
                  child: const Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  void _showProfileAlert(String title, UserProvider userProvider, HomePageProvider homePageProvider, UserContentProvider userContentProvider) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            insetAnimationCurve: Curves.decelerate,
            insetAnimationDuration: Duration(seconds: 1),
            actions: [
              CupertinoButton(
                  child: Text('프로필 사진 변경'),
                  onPressed: () {
                    addImages(userProvider, homePageProvider, userContentProvider);
                  }),
              CupertinoButton(child: Text('프로필 사진 삭제', style: TextStyle(color: Colors.red)), onPressed: () {}),
              CupertinoDialogAction(child: Text("취소"), onPressed: () => Navigator.pop(context)),
            ],
          );
        });
  }

  void addImages(UserProvider userProvider, HomePageProvider homePageProvider, UserContentProvider userContentProvider) async {
    XFile? images = await ImagePicker().pickImage(source: ImageSource.gallery);
    //마지막에 하자
  }
}
