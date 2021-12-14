import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/rankerprovider.dart';
import 'package:web/model/mywidget.dart';
import 'package:web/model/ranker.dart';
import 'package:web/page/ranker/rankerdetailpage.dart';

// ignore_for_file: avoid_print
class RankerPage extends StatefulWidget {
  const RankerPage({Key? key}) : super(key: key);

  @override
  _RankerPageState createState() => _RankerPageState();
}

class _RankerPageState extends State<RankerPage> {
  bool isRepeat = false;
  int gridCount = 10;

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    RankerProvider rankerProvider = Provider.of<RankerProvider>(context);
    rankerProvider.setProfileImageList(contentProvider.profileImage);
    List rankerContentList = rankerProvider.rankerContentList;
    return Center(
        child: Column(
      children: [
        AnimatedTextKit(repeatForever: true, isRepeatingAnimation: true, animatedTexts: [
          ColorizeAnimatedText('ASSA OF ASSA',
              speed: const Duration(seconds: 2), textStyle: const TextStyle(fontSize: 100), colors: MyWidget.colorizeColors)
        ]),
        const SizedBox(height: 50),
        GridView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemCount: rankerContentList.length,
            //item 개수
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 4, //item 의 가로 1, 세로 2 의 비율
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
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print('elebtn click $index');
                      rankerProvider.setDetailIndex(index);
                      navigatorPush(context, const RankerDetailPage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(rankerContent.profileImageStringUri)))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 200,
                                alignment: Alignment.center,
                                child: Text('(${rankerContent.userId})의 좋아요 : (${rankerContent.likeCount})', maxLines: 1,overflow: TextOverflow.clip)),
                            Container(
                                width: 200,
                                alignment: Alignment.center,
                                child: Text(contentTitle, style: const TextStyle(fontSize: 20), maxLines: 2, overflow: TextOverflow.clip)),
                          ],
                        ),
                        Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(rankerContent.contentImageStringUri)))),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white24,
                      elevation: 20,
                      animationDuration: const Duration(seconds: 4),
                    ),
                  ));
            }),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            print('10 pass');
            rankerProvider.getRankerContent();
          },
          style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colorChanger()), borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 300,
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                '10개 더보기',
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    ));
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
}
