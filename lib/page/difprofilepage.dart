import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/usercontentprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/content.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/user/profiledetailpage.dart';

import '../responsive.dart';

// ignore_for_file: avoid_print
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
        //Responsive.isLarge(context)            ?
        windows(userProvider, homePageProvider, userContentProvider, contentProvider)
           // : mobile(userProvider, homePageProvider)
    );
  }

  // Widget mobile(UserProvider userProvider, HomePageProvider homePageProvider) {
  //   return Container(width: 500,height: 500,color: Colors.redAccent,);
  // }

  Center windows(
      UserProvider userProvider, HomePageProvider homePageProvider, UserContentProvider userContentProvider, ContentProvider contentProvider) {
    String profileImage = '';
    profileImage = userProvider.difProfileImageString;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 700,
            height: 300,
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (profileImage == '')
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(width: 190.0, height: 190.0, child: Icon(Ionicons.person_add_outline, color: Colors.white, size: 80))),
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
                      DataColumn(label: InkWell(onTap: () {}, child: const Text(''))),
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
                    List<String> imagesUrlList = [];

                    for (var contentDataImages in contentData.images) {
                      ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentDataImages);
                      String fileName = imagesDataModel.filename;
                      String urlString = MyWord.imagesServerIpAndPort + fileName;
                      imagesUrlList.add(urlString);
                    }
                    return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: InkWell(
                            onTap: () {
                              userContentProvider.setPage(index);
                              navigatorPush(context, const ProfileDetailPage());
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(imagesUrlList[0]))))));
                  }),
            ),
          ),
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
}
