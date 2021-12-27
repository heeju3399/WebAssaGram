import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/dialog/dialog.dart';
import 'package:web/page/mobileDash/mobilehomepage/mobiledifprofiledetailpage.dart';

class MobileProfilePage extends StatefulWidget {
  const MobileProfilePage({Key? key}) : super(key: key);

  @override
  _MobileProfilePageState createState() => _MobileProfilePageState();
}

// ignore_for_file: avoid_print
class _MobileProfilePageState extends State<MobileProfilePage> {
  bool init = true;
  String profileImageUri = '';

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

  Future<bool> addImages(UserProvider userProvider, UserContentProvider userContentProvider) async {
    bool returnBool = false;
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    bool ok = isKorean(image!.name);
    if (ok) {
      MyDialog.setContentDialog(title: '한글이 포함되어 있습니다', message: '사진이름을 변경해 주세요', context: context);
    } else {
      userContentProvider.setProfileImage(userProvider.userId, userProvider.googleAccessId, image);
      returnBool = true;
    }
    return returnBool;
  }

  void _showProfileAlert(String title, UserProvider userProvider, UserContentProvider userContentProvider) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            insetAnimationCurve: Curves.decelerate,
            insetAnimationDuration: const Duration(seconds: 1),
            actions: [
              CupertinoButton(
                  child: const Text('프로필 사진 변경'),
                  onPressed: () {
                    addImages(userProvider, userContentProvider).then((value) => {
                          if (value) {Navigator.pop(context)}
                        });
                  }),
              CupertinoButton(
                  child: const Text('프로필 사진 삭제', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    userContentProvider.deleteProfileImage(userProvider.userId, userProvider.googleAccessId).then((value) {
                      Navigator.pop(context);
                    });
                  }),
              CupertinoDialogAction(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
    List userContentList = userContentProvider.userContentDataList;
    profileImageUri = userContentProvider.userProfileImageUri;
    if (init) {
      userContentProvider.initGetContent(userProvider.userId);
      init = false;
      setState(() {});
    }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('설정'),
                          insetAnimationCurve: Curves.decelerate,
                          insetAnimationDuration: const Duration(seconds: 1),
                          actions: [
                            CupertinoButton(
                                child: const Text('로그아웃'),
                                onPressed: () {
                                  userProvider.logOut();
                                  Navigator.pop(context);
                                }),
                            CupertinoButton(
                                child: const Text('게시물 삭제와  \n 회원탈퇴기능은 \n pc 버젼에서가능합니다', style: TextStyle(color: Colors.red)), onPressed: () {}),
                            CupertinoDialogAction(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                          ],
                        );
                      });
                },
                icon: const Icon(Ionicons.settings_outline)),
          ],
          backgroundColor: Colors.black,
          title: Padding(padding: const EdgeInsets.only(left: 15.0), child: Text(userProvider.userId, style: const TextStyle(color: Colors.white))),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 200,
                child: Row(
                  children: [
                    if (profileImageUri == '')
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                _showProfileAlert('사진변경', userProvider, userContentProvider);
                              },
                              child: const Icon(
                                Ionicons.person_add_outline,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          )),
                    if (profileImageUri != '')
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                _showProfileAlert('사진변경', userProvider, userContentProvider);
                              },
                              child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill, scale: 0.8, alignment: Alignment.center, image: NetworkImage(profileImageUri)))),
                            ),
                          )),
                    Expanded(
                        flex: 3,
                        child: Container(
                            color: Colors.black,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Text('${userContentProvider.contentCount}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                                        const Text('게시물', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(children: [
                                        Text('${userContentProvider.viewCount}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                                        const Text('조회수', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(children: [
                                        Text('${userContentProvider.likeCount}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                                        const Text('좋아요', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ]),
                                    ),
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Text('${userContentProvider.badCount}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                                        const Text('시러요', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(children: [
                                        Text('${userContentProvider.commentCount}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                                        const Text('댓글수', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(children: const [
                                        Text('4037', style: TextStyle(color: Colors.white, fontSize: 15)),
                                        Text('개발중', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      ]),
                                    ),
                                  ]),
                                ],
                              ),
                            ))),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                height: 10,
              ),
              Container(
                color: Colors.black,
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: userContentList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      ContentDataModel contentData = userContentList.elementAt(index);
                      List<String> imagesUrlList = [];
                      for (var contentDataImages in contentData.images) {
                        ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                        String fileName = imagesDataModel.filename;
                        String urlString = MyWord.imagesServerIpAndPort + fileName;
                        imagesUrlList.add(urlString);
                      }
                      return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                              onTap: () {
                                print('click detail page $index');
                                userContentProvider.setPage(index);
                                userContentProvider.setProfileImageString(profileImageUri);
                                ContentControl.navigatorPush(context, const MobileDifProfileDetailPage());
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(imagesUrlList.last))))));
                    }),
              ),
            ],
          ),
        ));
  }
}
