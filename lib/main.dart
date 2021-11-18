import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/page/maindash.dart';
import 'package:web/page/splash/splash.dart';


import 'model/provider/getcontent.dart';
import 'model/provider/mousehover.dart';
import 'model/provider/setcontent.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//   runApp(const MyApp());
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          // return ChangeNotifierProvider<MyProvider>(
          //   create: (BuildContext context) => MyProvider(),
          //   child: const MaterialApp(
          //     title: 'ASSA_GRAM',
          //     home: MainDash(),
          //   ),
          // );
          return MultiProvider(providers: [
            ChangeNotifierProvider<ContentProvider>(create: (BuildContext context) => ContentProvider()),
            ChangeNotifierProvider<SetContentProvider>(create: (BuildContext context) => SetContentProvider()),
            ChangeNotifierProvider<MouseHoverToggle>(create: (BuildContext context) => MouseHoverToggle()),
            //Provicer<Person>(create: (_) => Person(name: 'Yohan', age: 25)),
            //FutureProvider<String>(create: (context) => Home().fetchAddress),
          ], child: const MaterialApp(title: 'ASSA_GRAM', home: MainDash()));
        }
      },
    );
  }
}
//
// class oksk extends StatelessWidget {
//   const oksk({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: Scaffold(body: ImageUpload()));
//   }
// }
