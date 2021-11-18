import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/model/content.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  late XFile _image;
  final picker = ImagePicker();
  String url = 'http://172.30.1.19:3000';

  void ss() {}

  Future<void> getImage() async {
    //XFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  int cout = 0;

  upload() async {
    print('upload pass');
    List<XFile>? pickedFileList = await picker.pickMultiImage(imageQuality: 100, maxHeight: 100, maxWidth: 100);
    Uri uri = Uri.parse(url + '/uploads');
    MultipartRequest request = http.MultipartRequest("POST", uri);
    if (pickedFileList!.isNotEmpty) {
      for (var file in pickedFileList) {
        print('for pass');
        String mimeType = file.mimeType!;
        List mimeList = mimeType.split('/');
        String type = mimeList[0];
        String subType = mimeList[1];
        List<int> imageData = await file.readAsBytes();
        MultipartFile multipartFile = MultipartFile.fromBytes(
          'photo',
          imageData,
          filename: file.name,
          contentType: MediaType(type, subType),
        );
        request.files.add(multipartFile);
      }
      String flag = 'userDelete';
      String siteKey = 'secretKey';
      String userId = 'oksk';
      String content = '테스트 콘텐츠';

      Map<String, String> map = {};
      map = {"sitekey": siteKey, "flag": flag, "userid": userId};
      request.fields['PhoneNo'] = '1122';
      request.fields['content'] = content;
      request.headers.addAll(map);
      print(request.toString());
      try {
        StreamedResponse response = await request.send();
        int state = response.statusCode;
        print(response.statusCode);
        if (state == 200) {
          String respStr = await response.stream.bytesToString();
          print('=====================================');
          print(respStr);
          print(response.statusCode);
          print(response.headers);
          cout++;
          print('re count ???????? $cout');
        } else if (state == 500) {}
      } catch (e) {
        print('err $e');
      }
    }
  }

  bool isloaded = false;
  List imagesList = [];
  String ulr22 = '';
  fetch() async {
    //Image.network('http://172.30.1.19:3000/image')
    print('petch pass');
    //var response = await http.get(Uri.parse(url + '/image'));
    var response = await http.get(Uri.parse('http://172.30.1.19:3000/datacon'));
    var s1 = response.statusCode;
    var s2 = response.body;
    var s3 = response.headers;
    var s4 = response.bodyBytes;
    print('=============================');
  List<dynamic> returnList = [];
    //print(s2);
    Map result = jsonDecode(response.body);
    String title = result.values.elementAt(0);
    List message = result.values.elementAt(1);
    //print(message);
    for (Map<dynamic, dynamic> element1 in message) {
//여기서 갈기기
      //print('***************************************');

      ContentDataModel contentDataModel = ContentDataModel.fromJson(element1);
      returnList.add(contentDataModel);
    }
    //print(imagesList);
    for (ContentDataModel contentdata in returnList) {

      for (var element in contentdata.images) {

        ImagesDataModel imagesDataModel = ImagesDataModel.fromJson(element);
        print(imagesDataModel.path);
      }

      for (var element in contentdata.comment) {
        CommentDataModel commentDataModel = CommentDataModel.fromJson(element);
        print(commentDataModel.createTime);
        print('=============================');
      }

    }


    // String title = oksk['title'];
    // List message = oksk['message'];
    // for (var element in message) {
    //   print(element);
    // }
    // print('=============================');
    // setState(() {
    //   ulr22 = imagesList[0];
    //   isloaded = true;
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Select an image"),
            SizedBox(
              height: 100,
            ),
            FlatButton.icon(onPressed: () async => await getImage(), icon: Icon(Icons.upload_file), label: Text("Browse")),
            SizedBox(
              height: 100,
            ),
            FlatButton.icon(onPressed: () => upload(), icon: Icon(Icons.upload_rounded), label: Text("Upload now")),
            SizedBox(
              height: 100,
            ),
            isloaded
                //Container(width: 200, height: 200, color: Colors.green,)
                ? Image.network(ulr22)
                //? Container()
                : CircularProgressIndicator(),
            //isloaded ? Image.asset(null) : CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetch();
        },
        child: Icon(Icons.fourteen_mp_outlined),
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'dart:async';
// import 'package:async/async.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
//
// class ImageUpload extends StatefulWidget {
//   const ImageUpload({Key? key}) : super(key: key);
//
//   @override
//   _ImageUploadState createState() => _ImageUploadState();
// }
//
// class _ImageUploadState extends State<ImageUpload> {
//   late XFile _image;
//   bool ischeck = false;
//   final picker = ImagePicker();
//
//   Future<void> getImage() async {
//     //List<XFile>? images = await ImagePicker().pickMultiImage(imageQuality: 1000, maxHeight: 1000, maxWidth: 1000);
//     //final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = pickedFile;
//         ischeck = true;
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   upload(XFile imageFile) async {
//     try {
//       print('***********************$imageFile');
//       // open a bytestream
//       var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//       // get file length
//       print('0 (${imageFile.path})');
//       print('0 (${imageFile.readAsBytes()})');
//       print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
//       int length = await imageFile.length();
//       print('============================== $length');
//       // string to uri
//       //String url = 'http://172.30.1.19:3000/image';
//       var uri = Uri.parse("http://172.30.1.19:3000/upload");
//       print('1');
//       // create multipart request
//       var request = http.MultipartRequest("POST", uri);
//       print('2');
//       // multipart that takes file
//       var multipartFile = http.MultipartFile('myFile', stream, length, filename: basename(imageFile.path));
//       print('3');
//       // add file to multipart
//       request.files.add(multipartFile);
//       print('4');
//       // send
//       var response = await request.send();
//       print(response.statusCode);
//       print('5');
//       // listen for response
//       response.stream.transform(utf8.decoder).listen((value) {
//         print('6');
//         print(value);
//       });
//       print('7');
//     } catch (e) {
//       print(' err ??? $e');
//     }
//   }
//
//   bool isloaded = false;
//   var result;
//
//   fetch() async {
//     print('가져오기 패쓰');
//     String url = 'http://172.30.1.19:3000/image';
//     var response = await http.get(Uri.parse(url));
//     print(response.statusCode);
//
//
//     print(result[0]['image']);
//
//
//     setState(() {
//       isloaded = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     fetch();
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ischeck ? Container(width: 500, height: 300, child: Image.network(_image.path)) : CircularProgressIndicator(),
//           Text("Select an image"),
//           FlatButton.icon(onPressed: () async => await getImage(), icon: Icon(Icons.upload_file), label: Text("Browse")),
//           SizedBox(
//             height: 20,
//           ),
//           FlatButton.icon(onPressed: () => upload(_image), icon: Icon(Icons.upload_rounded), label: Text("Upload now")),
//           isloaded ? Image.network('http://172.30.1.19:3000/${result[0]['image']}') : CircularProgressIndicator(),
//         ],
//       ),
//     );
//   }
// }
