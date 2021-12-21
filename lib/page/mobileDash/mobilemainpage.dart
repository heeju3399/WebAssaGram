import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'package:web/model/myword.dart';
import 'package:web/page/mobileDash/mibilerankerpage/mobildrankerpage.dart';
import 'package:web/page/mobileDash/mobileprofilepage/mobildprofilepage.dart';
import 'package:web/page/mobileDash/mobilehomepage/mobilehomepage.dart';

import 'mobilehomepage/mobileloginpage.dart';

class MobileMainDashPage extends StatefulWidget {
  const MobileMainDashPage({Key? key}) : super(key: key);

  @override
  _MobileMainDashPageState createState() => _MobileMainDashPageState();
}

class _MobileMainDashPageState extends State<MobileMainDashPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const MobileHomePage(),
          const MobileRankerPage(),
          if (userProvider.userId != MyWord.LOGIN) const MobileProfilePage(),
          if (userProvider.userId == MyWord.LOGIN) const MobileSignPage(),
        ],
        controller: tabController,
      ),
      bottomNavigationBar: TabBar(controller: tabController, tabs: const [
        Tab(icon: Icon(Icons.home)),
        Tab(icon: Icon(Ionicons.shield_checkmark_outline)),
        Tab(icon: Icon(Ionicons.people)),
      ]),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('ddddd'),
//     ),
//     bottomSheet: Padding(
//       padding: EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           InkWell(onTap: () {}, child: Icon(Icons.home, size: 30)),
//           InkWell(onTap: () {}, child: Icon(Icons.people, size: 30)),
//           InkWell(onTap: () {}, child: Icon(Icons.favorite, size: 30)),
//         ],
//       ),
//     ),
//     body: Container(
//
//
//       color: Colors.red,
//     ),
//   );
// }
}
