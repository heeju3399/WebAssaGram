import 'dart:html' as html;
import 'package:flutter/material.dart';

// ignore_for_file: avoid_print
class SearchBuild extends StatefulWidget {
  const SearchBuild({Key? key}) : super(key: key);

  @override
  _SearchBuildState createState() => _SearchBuildState();
}

class _SearchBuildState extends State<SearchBuild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(width: 50, height: 50),
          const Text('관리자 메일', textScaleFactor: 2, style: TextStyle(color: Colors.white)),
          const SizedBox(width: 50, height: 30),
          const Text('heeju3399@naver.com', textScaleFactor: 2, style: TextStyle(color: Colors.white)),
          const SizedBox(width: 50, height: 30),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    html.window.open('mailto:heeju3399@naver.com', "_blank");
                  },
                  child: Container(alignment: Alignment.center, width: 200, height: 40, child: const Text('문의하기'))))
        ],
      ),
    );
  }
}
