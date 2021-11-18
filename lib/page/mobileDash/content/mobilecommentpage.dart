import 'dart:convert';
import 'package:realproject/model/content.dart';
import 'package:flutter/material.dart';

class MobileCommentPage extends StatefulWidget {
  const MobileCommentPage({Key key,  this.content}) : super(key: key);
  final MainContentDataModel content;

  @override
  _MobileCommentPageState createState() => _MobileCommentPageState(content: content);
}

class _MobileCommentPageState extends State<MobileCommentPage> {
  _MobileCommentPageState({ this.content});

  final MainContentDataModel content;
  double height = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    List<dynamic> utf8List = jsonDecode(content.content);
    List<int> intList = [];
    utf8List.forEach((element) {
      intList.add(element);
    });
    String contentString = utf8.decode(intList);
    return Scaffold(
        appBar: AppBar(title: Text('덧글 페이지 지울 수 있지만 저장되지 않습니다', style: TextStyle(fontSize: 15)), backgroundColor: Colors.white12),
        backgroundColor: Colors.black,
        body: SizedBox(
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(padding: EdgeInsets.all(20), child: Container(alignment: Alignment.center, child: Text('$contentString', textScaleFactor: 2, style: TextStyle(color: Colors.white)))),
          SingleChildScrollView(
              child: Center(
                  child: Container(
                      width: 490,
                      height: height - 140,
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            Map item = content.children[index];
                            MainCommentDataModel mainCommentDataModel = MainCommentDataModel.fromJson(item);
                            List<dynamic> utf8List2 = jsonDecode(mainCommentDataModel.comment);
                            List<int> intList2 = [];
                            utf8List2.forEach((element) {
                              intList2.add(element);
                            });
                            String commentString = utf8.decode(intList2);
                            return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Card(
                                    child: Container(
                                        decoration: BoxDecoration(color: Colors.black, border: Border.all(width: 1, color: Colors.white)),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Expanded(
                                              flex: 9,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('NO $index \n $commentString', overflow: TextOverflow.clip, maxLines: 5, style: TextStyle(fontSize: 15, color: Colors.white)))),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: IconButton(
                                                      icon: Icon(Icons.delete_forever),
                                                      color: Colors.white,
                                                      iconSize: 15,
                                                      onPressed: () {
                                                        content.children.removeAt(index);
                                                        setState(() {});
                                                      })))
                                        ]))));
                          },
                          itemCount: content.children.length,
                          shrinkWrap: true))))
        ])));
  }
}
