import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:web/control/content.dart';
import 'package:web/control/provider/contentprovider.dart';
import 'package:web/control/provider/homepageprovider.dart';
import 'package:web/control/provider/userprovider.dart';
import 'dialog/dialog.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController textFiledTitleController = TextEditingController();
  int imagesFullCount = 0;
  List<XFile> imagesList = [];

  @override
  Widget build(BuildContext context) {
    UserProvider loginProvider = Provider.of<UserProvider>(context);
    HomePageProvider homePageProvider = Provider.of<HomePageProvider>(context);
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    return addPage(context, loginProvider, homePageProvider, contentProvider);
  }

  Widget addPage(BuildContext context, UserProvider userProvider, HomePageProvider homePageProvider, ContentProvider contentProvider) {
    return Column(
      children: [
        SizedBox(
            width: 700,
            height: 100,
            child: TextField(
                controller: textFiledTitleController,
                style: const TextStyle(fontSize: 25, color: Colors.white),
                decoration: const InputDecoration(
                    labelText: '제목',
                    labelStyle: TextStyle(fontSize: 25, color: Colors.white),
                    suffixStyle: TextStyle(fontSize: 25, color: Colors.white),
                    hintStyle: TextStyle(fontSize: 25, color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))))), //제목

        //////////////// add picture ////////////////////////
        const SizedBox(height: 30),
        Consumer<ContentProvider>(builder: (context, provider, child) {
          print('provider build pass!!');
          if (imagesList.isNotEmpty) {
            return SizedBox(
              width: 700,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: imagesList.length, //item 개수
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    //childAspectRatio: 1 / 2, //item 의 가로 1, 세로 2 의 비율
                    // mainAxisSpacing: 10, //수평 Padding
                    // crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    print('grid build pass!! ');
                    XFile imgFile = imagesList.elementAt(index);
                    //print('***********************************!! ${imgFile.path}');
                    //item 의 반목문 항목 형성
                    return InkWell(
                      onLongPress: () {
                        print('pass : $index');
                        setState(() {
                          imagesList.removeAt(index);
                          imagesFullCount--;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(imgFile.path),
//               //Image.network(provider.image.path),
//               //if (provider.images != null)
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 100,
                child: Text('길게 누르면 지워집니다.', textScaleFactor: 2, style: TextStyle(color: Colors.white)),
              ),
            );
          }
        }),
        // 사진란// 사진란// 사진란// 사진란// 사진란// 사진란// 사진란// 사진란
        const SizedBox(height: 50),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  addImages();
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                child: Container(
                    width: 150,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('사진추가', style: TextStyle(fontSize: 20)))),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    imagesList.clear();
                    imagesFullCount = 0;
                  });
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: Container(
                    width: 150,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('전체삭제', style: TextStyle(fontSize: 20)))),
            ElevatedButton(
                onPressed: () {
                  callSetContentControl(context, userProvider).then((value) {
                    if (value) {
                      contentProvider.initGetContent();
                      imagesList.clear();
                      textFiledTitleController.clear();
                      homePageProvider.pageChange(0);
                    }
                  });
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                child: Container(
                    width: 150,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('저장', style: TextStyle(fontSize: 20)))),
          ],
        )),

        const SizedBox(height: 50),
        //사진 추가 버튼
      ],
    );
  }

  Future<bool> callSetContentControl(BuildContext context, UserProvider userProvider) async {
    bool resultBool = false;
    Map result = await ContentControl.setContent(title: textFiledTitleController.text, userProvider: userProvider, images: imagesList);
    if (result.values.elementAt(0) == 'pass') {
      resultBool = true;
    } else {
      MyDialog.setContentDialog(title: result.values.elementAt(0), message: result.values.elementAt(1), context: context);
    }

    return resultBool;
  }

  // void addImages() async {
  //   List<XFile>? images = await ImagePicker().pickMultiImage(imageQuality: 500, maxHeight: 500, maxWidth: 500);
  //   bool imagesFull = false;
  //   for (var element in images!) {
  //     if (imagesFullCount < 6) {
  //       imagesList.add(element);
  //       imagesFullCount++;
  //     } else {
  //       imagesFull = true;
  //     }
  //   }
  //   if (imagesFull) {
  //     MyDialog.setContentDialog(title: '초과', message: '최대 6개만 등록해주세요!', context: context);
  //   }
  //   setState(() {});
  // }

  void addImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(imageQuality: 500, maxHeight: 500, maxWidth: 500);
    bool imagesFull = false;
    bool isKo = false;

    int count = 0;
    for (var element in images!) {
      bool ok = isKorean(element.name);
      if (ok) {
        //사진이름을 바꾸어주세요 한글포함됨
        isKo = true;
      } else {
        if (imagesFullCount < 6) {
          imagesList.add(element);
          imagesFullCount++;
          count--;
        } else {
          imagesFull = true;
        }
      }
      count++;
    }
    if (isKo) {
      count = imagesList.length + count;
      MyDialog.setContentDialog(title: '한글이 포함되어 있습니다', message: '사진이름을 변경해 주세요', context: context);
    }
    if (imagesFull) {
      MyDialog.setContentDialog(title: '초과', message: '최대 6개만 등록해주세요!', context: context);
    }
    setState(() {});
  }

  bool isKorean(String input) {
    bool isKorean = false;
    int inputToUniCode = input.codeUnits[0];
    isKorean = (inputToUniCode >= 12593 && inputToUniCode <= 12643)
        ? true
        : (inputToUniCode >= 44032 && inputToUniCode <= 55203)
            ? true
            : false;
    return isKorean;
  }
}
