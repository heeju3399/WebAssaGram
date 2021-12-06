import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/page/maindash.dart';
import 'package:web/page/splash/splash.dart';
import 'control/provider/addpageprovider.dart';
import 'control/provider/contentprovider.dart';
import 'control/provider/homepageprovider.dart';
import 'control/provider/usercontentprovider.dart';
import 'control/provider/userprovider.dart';

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
            ChangeNotifierProvider<AddPageProvider>(create: (BuildContext context) => AddPageProvider()),
            ChangeNotifierProvider<HomePageProvider>(create: (BuildContext context) => HomePageProvider()),
            ChangeNotifierProvider<UserProvider>(create: (BuildContext context) => UserProvider()),
            ChangeNotifierProvider<UserContentProvider>(create: (BuildContext context) => UserContentProvider()),

            //Provicer<Person>(create: (_) => Person(name: 'Yohan', age: 25)),
            //FutureProvider<String>(create: (context) => Home().fetchAddress),
          ], child: const MaterialApp(title: 'ASSA_GRAM', home: MainDash()));
        }
      },
    );
  }
}


/*
*
  void detailPage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(1),
              titlePadding: EdgeInsets.all(1),
              actionsOverflowButtonSpacing: 0,
              elevation: 0,
              buttonPadding: EdgeInsets.all(1),
              title: SizedBox(
                width: 700,
                height: 500,
                child: Row(
                  children: [
                    Container(
                      width: 500,
                      height: 400,
                      color: Colors.red,
                    ),
                    Container(
                      width: 200,
                      height: 400,
                      color: Colors.lightGreenAccent,
                    ),
                  ],
                ),
              ));
        });
  }
*
* */

//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Future.delayed(const Duration(seconds: 2)),
//       builder: (context, AsyncSnapshot snapshot) {
//         // Show splash screen while waiting for app resources to load:
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(home: Splash());
//         } else {
//           // return ChangeNotifierProvider<MyProvider>(
//           //   create: (BuildContext context) => MyProvider(),
//           //   child: const MaterialApp(
//           //     title: 'ASSA_GRAM',
//           //     home: MainDash(),
//           //   ),
//           // );
//           return MultiProvider(providers: [
//             ChangeNotifierProvider<ContentProvider>(create: (BuildContext context) => ContentProvider()),
//             ChangeNotifierProvider<AddPageProvider>(create: (BuildContext context) => AddPageProvider()),
//             ChangeNotifierProvider<HomePageProvider>(create: (BuildContext context) => HomePageProvider()),
//             ChangeNotifierProvider<UserProvider>(create: (BuildContext context) => UserProvider()),
//             ChangeNotifierProvider<UserContentProvider>(create: (BuildContext context) => UserContentProvider()),
//
//             //Provicer<Person>(create: (_) => Person(name: 'Yohan', age: 25)),
//             //FutureProvider<String>(create: (context) => Home().fetchAddress),
//           ], child: const MaterialApp(title: 'ASSA_GRAM', home: MainDash()));
//         }
//       },
//     );
//   }
// }
