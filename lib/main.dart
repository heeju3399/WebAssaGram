import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/page/maindash.dart';
import 'package:web/page/splash/splash.dart';
import 'control/provider/contentprovider.dart';
import 'control/provider/homepageprovider.dart';
import 'control/provider/rankerprovider.dart';
import 'control/provider/usercontentprovider.dart';
import 'control/provider/userprovider.dart';

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          return MultiProvider(providers: [
            ChangeNotifierProvider<ContentProvider>(create: (BuildContext context) => ContentProvider()),
            ChangeNotifierProvider<HomePageProvider>(create: (BuildContext context) => HomePageProvider()),
            ChangeNotifierProvider<UserProvider>(create: (BuildContext context) => UserProvider()),
            ChangeNotifierProvider<UserContentProvider>(create: (BuildContext context) => UserContentProvider()),
            ChangeNotifierProvider<RankerProvider>(create: (BuildContext context) => RankerProvider()),
          ], child: const MaterialApp(title: 'ASSA_GRAM', home: MainDash()));
        }
      },
    );
  }
}
