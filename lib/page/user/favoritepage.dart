import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:web/model/mywidget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool isRepeat = false;
  int gridCount = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        AnimatedTextKit(repeatForever: true, isRepeatingAnimation: true, animatedTexts: [
          ColorizeAnimatedText('King Of Ranker',
              speed: const Duration(seconds: 2), textStyle: const TextStyle(fontSize: 100), colors: MyWidget.colorizeColors)
        ]),
        const SizedBox(height: 50),
        GridView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemCount: gridCount,
            //item 개수
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 4, //item 의 가로 1, 세로 2 의 비율
            ),
            itemBuilder: (BuildContext context, int index) {
              print('grid build pass!! $index');
              // XFile imgFile = imagesList.elementAt(index);
              //item 의 반목문 항목 형성
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print('elebtn click $index');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /////////////
                        // Container(
                        //     decoration: BoxDecoration(
                        //         borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
                        //         shape: BoxShape.rectangle,
                        //         image: DecorationImage(fit: BoxFit.fill, image: NetworkImage('')))),
                        Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                        ///////////////
                        Text('userid'),
                        Text('like count?'),
                        Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.rectangle)),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
                        //         shape: BoxShape.rectangle,
                        //         image: DecorationImage(fit: BoxFit.fill, image: NetworkImage('')))),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white24,
                      elevation: 20,
                      animationDuration: Duration(seconds: 4),
                    ),
                  ));
            }),

        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            print('10 pass');
            setState(() {
              gridCount = gridCount + 10;
            });
          },
          style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient:  LinearGradient(
                    colors: colorChanger()),
                borderRadius: BorderRadius.circular(20)),
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



  List<Color> colorChanger(){
    List<Color> colorList = [
      Colors.redAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
    ];
    colorList.shuffle();
    return colorList;
  }

}
