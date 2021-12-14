import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/model/myword.dart';
import 'package:web/server/nodeserver.dart';

import '../user.dart';

class UserProvider extends ChangeNotifier {
  String userId = MyWord.LOGIN;
  String googleAccessId = '';
  late GoogleSignInAccount account;
  late GoogleSignInAuthentication auth;
  bool gotProfile = false;
  late GoogleSignIn googleSignIn;
  String visitantId = '';
  String contentId = '';
  String myProfileImageString = '';
  String difProfileImageString = '';
  List profileImageList = [];

  late XFile? profileImage;
  bool isProfileImage = false;

  void setProfileImagesList(List images) {
    profileImageList = images;
  }

  void setDifProfileImageStringUri(String imgString) {
    difProfileImageString = imgString;
  }

  String getProfileImage() {
    String returnString = '';
    try {
      Map ss = profileImageList.firstWhere((e) => e['userId'] == userId);
      Map sss = ss['images'];
      String profileImageName = sss['filename'].toString();
      myProfileImageString = 'http://172.30.1.19:3000/view/' + profileImageName;
      returnString = myProfileImageString;
    } catch (e) {
      print('err $e');
    }
    return returnString;
    //print(myProfileImageString);
  }

  Future<int> signIn(String id, String pass) async {
    int resultStateCode = 0;
    List resultList = await NodeServer.signIn(id, pass);
    if (resultList.elementAt(0) == 1) {
      String imageString = resultList.elementAt(1).toString();
      userId = id;
      resultStateCode = 1;
    } else if (resultList.elementAt(0) == 2) {
      resultStateCode = 2;
    } else {
      resultStateCode = 0;
    }
    return resultStateCode;
  }

  void setContentId(String contentId) {
    this.contentId = contentId;
  }

  void setVisitantId(String visitantId) {
    this.visitantId = visitantId;
  }

  void setProfileImage(XFile profileImage) {
    this.profileImage = profileImage;
  }

  void deleteProfileImage() {}

  Future<bool> userWithdrawal(String userId) async {
    bool returnBool = false;
    returnBool = await NodeServer.userWithdrawal(userId, googleAccessId);
    return returnBool;
  }

  void setUserId(String userId) {
    this.userId = userId;
    notifyListeners();
  }

  void logOut() {
    try {
      userId = MyWord.LOGIN;
      googleAccessId = '';
      googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<int> googleLogin() async {
    print('google login provider pass');
    int result = 0;
    googleSignIn = GoogleSignIn(
      clientId: '733023707194-bnt5dj1dcqtvhdcg5g9hsq8j31qr6m7b.apps.googleusercontent.com',
      scopes: [
        'https://www.googleapis.com/auth/youtube.readonly',
        'https://www.googleapis.com/auth/youtube',
        'https://www.googleapis.com/auth/youtube.force-ssl'
      ],
    );
    try {
      account = (await googleSignIn.signIn())!;
      await googleSignIn.signInSilently();
      account = googleSignIn.currentUser!;
      print(account.toString());
      auth = await account.authentication;
      print(auth.toString());
      var result7 = auth.accessToken;
      print(result7);
      print('======================================');

      result = 1;
    } catch (e) {
      print(e.toString());
    }
    if (result == 1) {

      String displayName = account.displayName!.toString();
      String email = account.email.toString();
      String id = account.id.toString();
      print('=============================');
      print('display name : ' + displayName);
      print('email : ' + email);
      print('id : 4521622343325723414678');
      print(account.photoUrl);
      print(account.authHeaders);
      if (id.isNotEmpty) {
        googleAccessId = id;
        bool result2 = await UserControl.googleLogin(email, displayName, id);
        if (result2) {
          userId = displayName;
        } else {
          result = 2;
        }
      }
    }
    //pass 되었다 치고
    // String email = 'oksk@gmail.com';
    // String displayName = 'okok9990';
    // String id = '321321231321321';
    //result = await UserControl.googleLogin(email, displayName, id);
    return result;
  }
}
