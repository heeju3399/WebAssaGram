// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:provider/provider.dart';
// import 'package:web/control/provider/usercontentprovider.dart';
// import 'package:web/model/content.dart';
//
// import '../../responsive.dart';
//
// class ProfileDetailPage extends StatefulWidget {
//   const ProfileDetailPage({Key? key, required this.profileIndex, required this.allContentIndex}) : super(key: key);
//   final int profileIndex;
//   final int allContentIndex;
//
//   @override
//   _ProfileDetailPageState createState() => _ProfileDetailPageState();
// }
//
// class _ProfileDetailPageState extends State<ProfileDetailPage> {
//
//   bool selected = false;
//   late PageController mainPageController8888;
//   final List<PageController> pageController2 = [];
//   bool pageIsScrolling = false;
//   bool onePass = true;
//
//   @override
//   void initState() {
//     super.initState();
//     print('ProfileDetailPage init pass ${widget.allContentIndex}');
//     mainPageController8888 = PageController();
//     timer();
//
//   }
//
//   @override
//   void dispose() {
//     //mainPageController8888.dispose();
//     //pageController2[pageController2.length].dispose();
//     print('ProfileDetailPage dispose pass');
//     super.dispose();
//   }
//
//   void timer() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     setState(() {
//       selected = !selected;
//     });
//   }
//
//   int justonemoretime = 0;
//   void passPage()async{
//
//     print('==========page? ${widget.profileIndex} /// ${justonemoretime}');
//     if(justonemoretime == 0){
//       print('ture?!!!!!!!!!!!!!');
//       await Future.delayed(Duration(seconds: 2));
//        mainPageController8888.animateToPage(widget.profileIndex, duration: const Duration(milliseconds: 100), curve: Curves.slowMiddle);
//
//       justonemoretime++;
//     }else{
//       print('false??????????????????');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserContentProvider userContentProvider = Provider.of<UserContentProvider>(context);
//     //UserProvider userProvider = Provider.of<UserProvider>(context);
//     return Responsive.isLarge(context) ? windows(userContentProvider) : mobile();
//   }
//
// int ccc =0;
//
//   Widget windows(UserContentProvider userContentProvider) {
//
//     print('window apss : ${userContentProvider.userContentDataList.length}');
//     return Scaffold(
//         backgroundColor: Colors.black12.withOpacity(0.8),
//         body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Stack(children: [
//               AnimatedPositioned(
//                 top: selected ? 30 : 500,
//                 bottom: selected ? 30 : 500,
//                 right: selected ? 100 : 500,
//                 left: selected ? 100 : 500,
//                 duration: const Duration(seconds: 1),
//                 curve: Curves.fastOutSlowIn,
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: AnimatedOpacity(
//                     opacity: selected ? 1.0 : 0.0,
//                     duration: const Duration(milliseconds: 500),
//                     //////////////// all page view //////////////////////////////
//                     child: PageView.builder(
//                       controller: mainPageController8888,
//                       itemCount: userContentProvider.userContentDataList.length, //콘텐츠 갯수
//                       itemBuilder: (BuildContext context, int mainPageIndex) {
//
//                         print('all page view pass 총 8개가 만들어 지나? ${ccc}');
//                         ccc++;
//                         print('((((((((((((((( ${userContentProvider.userContentDataList.length} )))))))))))))))))');
//
//                         pageController2.add(PageController());
//                         List contentDataList = userContentProvider.userContentDataList;
//                         ContentDataModel contentData = contentDataList[mainPageIndex];
//                         return Container(
//                           child: Row(
//                             children: [
//                               ////////////////////////////// images ///////////////////////////////
//                               Expanded(
//                                 child: Stack(
//                                   children: [
//                                     PageView.builder(
//                                       //이미지가 들어올 페이지
//                                       controller: pageController2[mainPageIndex],
//                                       onPageChanged: (int page) {
//                                         setState(() {
//                                           selectedindex = page;
//                                         });
//                                       },
//                                       itemCount: contentData.images.length,
//                                       itemBuilder: (BuildContext context, int pageIndex) {
//                                         ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(contentData.images[pageIndex]);
//                                         String fileName = imagesDataModel.filename;
//                                         String urlString = 'http://172.30.1.19:3000/view/$fileName';
//                                         //passPage();
//                                         return Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Image.network(urlString, fit: BoxFit.fill, alignment: Alignment.center));
//                                         // child: Container(
//                                         //   color: Colors.deepPurple,
//                                         //   child: Text(
//                                         //     'mainPageIndex :  $mainPageIndex /pageIndex  $pageIndex',
//                                         //     textScaleFactor: 2,
//                                         //     style: TextStyle(color: Colors.white),
//                                         //   ),
//                                         // ),
//                                         //);
//                                       },
//                                     ),
//                                     AnimatedPositioned(
//                                         right: 10,
//                                         top: 500,
//                                         duration: const Duration(seconds: 1),
//                                         curve: Curves.fastOutSlowIn,
//                                         child: GestureDetector(
//                                             onTap: () {
//                                               print('next!!!!!!!!!');
//                                               pageController2[mainPageIndex]
//                                                   .nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
//                                             },
//                                             child: AnimatedOpacity(
//                                                 opacity: selected ? 1.0 : 0.0,
//                                                 duration: const Duration(milliseconds: 500),
//                                                 child: const Icon(Ionicons.arrow_forward_circle_sharp, color: Colors.grey, size: 40)))),
//                                     AnimatedPositioned(
//                                         left: 10,
//                                         top: 500,
//                                         duration: const Duration(seconds: 1),
//                                         curve: Curves.fastOutSlowIn,
//                                         child: GestureDetector(
//                                             onTap: () {
//                                               print('forward !!!!!!!!!!!!!!');
//                                               pageController2[mainPageIndex]
//                                                   .previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
//                                             },
//                                             child: AnimatedOpacity(
//                                                 opacity: selected ? 1.0 : 0.0,
//                                                 duration: const Duration(milliseconds: 500),
//                                                 child: const Icon(Ionicons.arrow_back_circle_sharp, color: Colors.grey, size: 40)))),
//                                   ],
//                                 ),
//                                 flex: 2,
//                               ),
//                               ////////////////////////////// images ///////////////////////////////
//                               ////////////////////////////// comment ///////////////////////////////
//                               Expanded(
//                                 child:Container(
//                                   width: 500,
//                                   color: Colors.red,
//                                   child: Column(
//                                     children: [
//                                       Expanded(child: Container(color: Colors.greenAccent,),flex: 1,),
//                                       Expanded(child: Container(color: Colors.red,),flex: 2,),
//                                       Expanded(child: Container(color: Colors.grey,),flex: 1,),
//                                       Expanded(child: Container(color: Colors.orange,),flex: 1,),
//                                     ],
//                                   ),
//                                 ),
//                                 flex: 1,
//                               ),
//                               ////////////////////////////// comment ///////////////////////////////
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     //////////////// all page view //////////////////////////////
//                   ),
//                 ),
//               ),
//               AnimatedPositioned(
//                   right: selected ? 20 : 0,
//                   top: selected ? 20 : 0,
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.fastOutSlowIn,
//                   child: GestureDetector(
//                       onTap: () {
//                         print('?????????');
//                         pagedown();
//                       },
//                       child: AnimatedOpacity(
//                           opacity: selected ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 500),
//                           child: const Icon(Icons.cancel, color: Colors.red, size: 60)))),
//               AnimatedPositioned(
//                   right: selected ? 10 : 0,
//                   top: selected ? 420 : 0,
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.fastOutSlowIn,
//                   child: GestureDetector(
//                       onTap: () {
//                         print('!!!!!!!!!!!!');
//                         main_page_right();
//                       },
//                       child: AnimatedOpacity(
//                           opacity: selected ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 500),
//                           child: const Icon(Ionicons.arrow_forward_circle_sharp, color: Colors.grey, size: 40)))),
//               AnimatedPositioned(
//                   left: selected ? 10 : 0,
//                   top: selected ? 420 : 0,
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.fastOutSlowIn,
//                   child: GestureDetector(
//                       onTap: () {
//                         print('@@@@@@@@@@@@@');
//                         main_page_left();
//                       },
//                       child: AnimatedOpacity(
//                           opacity: selected ? 1.0 : 0.0,
//                           duration: const Duration(milliseconds: 500),
//                           child: const Icon(Ionicons.arrow_back_circle_sharp, color: Colors.grey, size: 40)))),
//             ])),
//     floatingActionButton: FloatingActionButton(
//       onPressed: (){
//         passPage();
//       },
//       child: const Icon(Icons.account_balance_wallet_sharp),
//     ),
//     );
//
//   }
//
//   int selectedindex = 0;
//
//   List<Widget> _buildPageIndicator(int len) {
//     List<Widget> list = [];
//     for (int i = 0; i < len; i++) {
//       list.add(i == selectedindex ? _indicator(true) : _indicator(false));
//     }
//     return list;
//   }
//
//   Widget _indicator(bool isActive) {
//     return Container(
//       height: 10,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 150),
//         margin: EdgeInsets.symmetric(horizontal: 4.0),
//         height: isActive
//             ? 10:8.0,
//         width: isActive
//             ? 12:8.0,
//         decoration: BoxDecoration(
//           boxShadow: [
//             isActive
//                 ? BoxShadow(
//               color: Color(0XFF2FB7B2).withOpacity(0.72),
//               blurRadius: 4.0,
//               spreadRadius: 1.0,
//               offset: Offset(
//                 0.0,
//                 0.0,
//               ),
//             )
//                 : BoxShadow(
//               color: Colors.transparent,
//             )
//           ],
//           shape: BoxShape.circle,
//           color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
//         ),
//       ),
//     );
//   }
//
//   Widget mobile() {
//     return Container();
//   }
//
//   void pagedown() async {
//     setState(() {
//       selected = !selected;
//     });
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (onePass) {
//       print('one pass');
//       setState(() {
//         onePass = false;
//       });
//       Navigator.of(context).pop();
//     }
//   }
//
//   void main_page_right() {
//     mainPageController8888.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
//     print('next');
//   }
//
//   void main_page_left() {
//     print('preview');
//     mainPageController8888.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
//   }
//
//   void mainPageScroll(double offset, int index) {
//     //print(offset);
//     if (pageIsScrolling == false) {
//       pageIsScrolling = true;
//       if (offset > 0) {
//         pageController2[index]
//             .previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
//             .then((value) => pageIsScrolling = false);
//         print('scroll down');
//       } else {
//         pageController2[index]
//             .nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
//             .then((value) => pageIsScrolling = false);
//         print('scroll up');
//       }
//     }
//   }
//
//   void imagesPageScroll(double offset, int index) {
//     //print(offset);
//     if (pageIsScrolling == false) {
//       pageIsScrolling = true;
//       if (offset > 0) {
//         pageController2[index]
//             .previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
//             .then((value) => pageIsScrolling = false);
//         print('scroll down');
//       } else {
//         pageController2[index]
//             .nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
//             .then((value) => pageIsScrolling = false);
//         print('scroll up');
//       }
//     }
//   }
//
//
// }
// /*
// *  body: Center(
//         // 투명도 애니메이션 효과를 제공하는 위젯 추가
//         child: AnimatedOpacity(
//           // 필드값에 따라 출력 여부를 토클함
//           opacity: _visible ? 1.0 : 0.0,
//           // 애미메이션 효과에 소요되는 시간 설정
//           duration: Duration(milliseconds: 500),
//           // 컨테이너 추가
//           child: Container(
//             // 컨테이너의 너비, 높이, 색상 설정
//             width: 200.0,
//             height: 200.0,
//             color: Colors.green,
//           ),
//         ),
//       ),
// *
// *
// * */
