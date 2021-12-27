import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/rankerprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/ranker.dart';
import 'package:web/page/mobileDash/mobilehomepage/mobiledifprofilepage.dart';

// ignore_for_file: avoid_print
class MobileRankerPage extends StatefulWidget {
  const MobileRankerPage({Key? key}) : super(key: key);

  @override
  _MobileRankerPageState createState() => _MobileRankerPageState();
}

class _MobileRankerPageState extends State<MobileRankerPage> {
  bool isRepeat = false;
  int gridCount = 10;
  List<Color> colorList = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
  ];

  final Gradient _gradient = const LinearGradient(
    colors: [
      Colors.white,
      Colors.yellow,
      Colors.orange,
      Colors.purpleAccent,
      Colors.greenAccent,
      Colors.white,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    RankerProvider rankerProvider = Provider.of<RankerProvider>(context);
    rankerProvider.setProfileImageList(contentProvider.profileImageList);
    List rankerContentList = rankerProvider.rankerContentList;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
            child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.all(28.0),
                child: ShaderMask(
                    blendMode: BlendMode.modulate,
                    shaderCallback: (size) => _gradient.createShader(
                          Rect.fromLTWH(0, 0, size.width, size.height),
                        ),
                    child: const Text('ASSA OF ASSA',
                        style: TextStyle(fontSize: 40, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white)))),
            const SizedBox(height: 30),
            GridView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: rankerContentList.length,
                //item 개수
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 5, //item 의 가로 1, 세로 2 의 비율
                ),
                itemBuilder: (BuildContext context, int index) {
                  RankerContentDataModel rankerContent = rankerContentList.elementAt(index);

                  String contentTitle = '';
                  List<dynamic> utf8List2 = jsonDecode(rankerContent.content);
                  List<int> intList = [];
                  for (var element in utf8List2) {
                    intList.add(element);
                  }
                  contentTitle = utf8.decode(intList);
                  return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    contentPadding: const EdgeInsets.all(8.0),
                                    buttonPadding: const EdgeInsets.all(2.0),
                                    titlePadding: const EdgeInsets.all(5.0),
                                    shape: ContinuousRectangleBorder(
                                        side: const BorderSide(color: Colors.blueAccent), borderRadius: BorderRadius.circular(30)),
                                    title: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                      ),
                                      onPressed: () {
                                        userProvider.setDifProfileImageStringUri(rankerContent.profileImageStringUri);
                                        print('content user id?!!! ${userProvider.userId}');
                                        userProvider.setDifChooseContentUserId(rankerContent.userId);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileDifProfilePage()));
                                      },
                                      child: Text(rankerContent.userId, textScaleFactor: 2),
                                    ),
                                    content: Container(
                                        width: 200,
                                        height: 250,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(rankerContent.contentImageStringUri)))));
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(rankerContent.profileImageStringUri)))),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    child: Text('(${rankerContent.userId})의 좋아요 : (${rankerContent.likeCount})',
                                        maxLines: 1, overflow: TextOverflow.clip)),
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(contentTitle, style: const TextStyle(fontSize: 15), maxLines: 2, overflow: TextOverflow.clip)),
                              ],
                            ),
                            Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(rankerContent.contentImageStringUri)))),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white24,
                          elevation: 10,
                          animationDuration: const Duration(seconds: 4),
                        ),
                      ));
                }),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: ElevatedButton(
                onPressed: () {
                  print('10 pass');
                  rankerProvider.getRankerContent();
                },
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: Ink(
                  decoration: BoxDecoration(gradient: LinearGradient(colors: colorChanger()), borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      '10개 더보기',
                      style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10, height: 50),
          ],
        )),
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
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  List<Color> colorChanger() {
    List<Color> colorList = [
      Colors.redAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
    ];
    colorList.shuffle();
    return colorList;
  }

  List<Color> colorChanger333() {
    List<Color> colorList = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
    ];
    colorList.shuffle();
    return colorList;
  }
}
