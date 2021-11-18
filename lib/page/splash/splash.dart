import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.yellow,
      Colors.red,
      Colors.lightBlueAccent,
      Colors.yellow,
      Colors.red,
      Colors.lightBlueAccent,
      Colors.yellow,
      Colors.red,
      Colors.lightBlueAccent,
      Colors.yellow,
      Colors.red,
      Colors.lightBlueAccent,
    ];

    bool lightMode = MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode ? Colors.white : Colors.black,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'ASSA_GRAM',
              speed: const Duration(seconds: 2),
              textStyle: const TextStyle(fontSize: 100),
              colors: colorizeColors,
            ),
          ],
          isRepeatingAnimation: true,
        ),
      ),
    );
  }
}