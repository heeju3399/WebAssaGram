import 'dart:convert';
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
import 'package:web/model/myword.dart';
import 'package:web/page/dialog/dialog.dart';
import 'package:web/page/user/profiledetailpage.dart';

// ignore_for_file: avoid_print
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProFileState createState() => _ProFileState();
}

class _ProFileState extends State<ProfilePage> {
  bool reload = true;
  int contentId2 = 0;
  int listViewLength = 0;
  bool init = true;

  @override
  void dispose() {
    print('profile dispose pass');
    init = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    HomePageProvider homePageProvider = Provider.of<HomePageProvider>(context);
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);

    if (init) {
      userContentProvider.initGetContent(userProvider.userId);
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
  //               child: Text('${userProvider.userId} ?????? ???',
  //                   maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontSize: 15, color: Colors.white))),
  //           const Padding(
  //               padding: EdgeInsets.only(top: 10),
  //               child: Text('?????? ????????? ???????????????', maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontSize: 15, color: Colors.white))),
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
  //                             Text('????????????', style: TextStyle(color: Colors.white))
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
  //                       child: Text('????????????', textScaleFactor: 2, style: TextStyle(color: Colors.white)))),
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
  //                         child: Text('????????????', textScaleFactor: 2, style: TextStyle(color: Colors.white)))))
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Center windows(
      UserProvider userProvider, HomePageProvider homePageProvider, UserContentProvider userContentProvider, ContentProvider contentProvider) {
    String profileImage = '';
    userContentProvider.initProfileImage(contentProvider, userProvider.userId);
    profileImage = userContentProvider.userProfileImageUri;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 700,
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (profileImage == '')
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            print('profile image call');
                            _showProfileAlert('????????? ?????? ??????', userProvider, homePageProvider, userContentProvider);
                          },
                          child: const SizedBox(
                              width: 190.0,
                              height: 190.0,
                              child: Icon(
                                Ionicons.person_add_outline,
                                color: Colors.white,
                                size: 80,
                              )))),
                if (profileImage != '')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        print('profile image call');
                        _showProfileAlert('????????? ?????? ??????', userProvider, homePageProvider, userContentProvider);
                      },
                      child: Container(
                          width: 190.0,
                          height: 190.0,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(profileImage)))),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text(userProvider.userId, style: const TextStyle(color: Colors.white, fontSize: 20))),
                      DataColumn(
                          label: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: () {
                          _showSettingAlert(contentProvider, '??????', userProvider, homePageProvider, userContentProvider);
                        },
                        child: const Text('??????', style: TextStyle(color: Colors.redAccent, fontSize: 20)),
                      )),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('????????? (${userContentProvider.contentCount})', style: const TextStyle(color: Colors.white, fontSize: 20))),
                          DataCell(Text('????????? (${userContentProvider.viewCount})', style: const TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('????????? (${userContentProvider.likeCount})', style: const TextStyle(color: Colors.white, fontSize: 20))),
                          DataCell(Text('????????? (${userContentProvider.commentCount})', style: const TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('????????? (${userContentProvider.badCount})', style: const TextStyle(color: Colors.white, fontSize: 20))),
                          const DataCell(Text('', style: TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
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
                      itemCount: userContentProvider.userContentDataList.length, //item ??????
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        List userContentList = userContentProvider.userContentDataList;
                        listViewLength = userContentList.length;
                        ContentDataModel contentData = userContentList[index];
                        int contentId = contentData.contentId;
                        List<String> imagesUrlList = [];
                        for (var contentDataImages in contentData.images) {
                          ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                          String fileName = imagesDataModel.filename;
                          String urlString =  MyWord.imagesServerIpAndPort+fileName;
                          imagesUrlList.add(urlString);
                        }
                        return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: InkWell(
                                onTap: () {
                                  userContentProvider.setPage(index);
                                  navigatorPush(context, const ProfileDetailPage());
                                },
                                onLongPress: () {
                                  _showDeleteAlert(
                                      userContentProvider, contentProvider, index, userProvider.userId, contentData.content, contentId);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(imagesUrlList[0]))))));
                      }))),
          const SizedBox(height: 100)
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
            title: const Text('?????????????????????????'),
            content: Text('?????? : $consentString'),
            insetAnimationCurve: Curves.decelerate,
            insetAnimationDuration: const Duration(seconds: 1),
            actions: [
              CupertinoButton(
                child: const Text('????????? ?????? ??????', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  print('?????? ?????? ??????');
                  userContentProvider.deleteAllContent(userId).then((value) {
                    if (value) {
                      contentProvider.deleteUserAllContent(userId);
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              CupertinoButton(
                  child: const Text('????????? ??????', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    userContentProvider.deleteContent(index, userId, contentId);
                    contentProvider.deleteUserContent(contentId);
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                  child: const Text("??????"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
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
                  child: const Text('????????????'),
                  onPressed: () {
                    userProvider.logOut();
                    homePageProvider.pageChange(0);
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('????????? ?????? ??????', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    print('?????? ?????? ??????');
                    userContentProvider.deleteAllContent(userProvider.userId).then((value) {
                      if (value) {
                        contentProvider.deleteUserAllContent(userProvider.userId);
                        Navigator.pop(context);
                      }
                    });
                  }),
              CupertinoButton(
                  child: const Text('?????? ??????', style: TextStyle(color: Colors.black)),
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
              CupertinoButton(child: const Text('????????? 1??? ????????? ??? ??????'), onPressed: () {}),
              CupertinoDialogAction(
                  child: const Text("??????"),
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
            insetAnimationDuration: const Duration(seconds: 1),
            actions: [
              CupertinoButton(
                  child: const Text('????????? ?????? ??????'),
                  onPressed: () {
                    addImages(userProvider, homePageProvider, userContentProvider).then((value) => {
                          if (value) {Navigator.pop(context)}
                        });
                  }),
              CupertinoButton(
                  child: const Text('????????? ?????? ??????', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    userContentProvider
                        .deleteProfileImage(userProvider.userId, userProvider.googleAccessId)
                        .then((value) => {Navigator.pop(context)});
                  }),
              CupertinoDialogAction(child: const Text("??????"), onPressed: () => Navigator.pop(context)),
            ],
          );
        });
  }

  Future<bool> addImages(UserProvider userProvider, HomePageProvider homePageProvider, UserContentProvider userContentProvider) async {
    bool returnBool = false;
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    bool ok = isKorean(image!.name);
    if (ok) {
      MyDialog.setContentDialog(title: '????????? ???????????? ????????????', message: '??????????????? ????????? ?????????', context: context);
    } else {
      userContentProvider.setProfileImage(userProvider.userId, userProvider.googleAccessId, image);
      returnBool = true;
    }
    return returnBool;
  }

  bool isKorean(String input) {
    bool isKorean = false;
    int inputToUniCode = input.codeUnits[0];
    isKorean = (inputToUniCode >= 12593 && inputToUniCode <= 12643)
        ? true
        : (inputToUniCode >= 44032 && inputToUniCode <= 55203)
            ? true
            : false;
    return isKorean;
  }
}
