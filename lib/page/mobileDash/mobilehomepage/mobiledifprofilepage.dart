import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'mobiledifprofiledetailpage.dart';

class MobileDifProfilePage extends StatefulWidget {
  const MobileDifProfilePage({Key? key}) : super(key: key);

  @override
  _MobileDifProfilePageState createState() => _MobileDifProfilePageState();
}

class _MobileDifProfilePageState extends State<MobileDifProfilePage> {
  bool init = true;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);

    List userContentList = userContentProvider.userContentDataList;
    String profileImage = '';
    profileImage = userProvider.difProfileImageString;

    if (init) {
      userContentProvider.initGetContent(userProvider.difChooseContentUserId);
      init = false;
      setState(() {});
    }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black, title: Text(userProvider.difChooseContentUserId, style: const TextStyle(color: Colors.white))),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image:
                                      DecorationImage(fit: BoxFit.fill, scale: 0.8, alignment: Alignment.center, image: NetworkImage(profileImage)))),
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
                    //item 개수
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
                                userContentProvider.setPage(index);
                                userContentProvider.setProfileImageString(profileImage);
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
