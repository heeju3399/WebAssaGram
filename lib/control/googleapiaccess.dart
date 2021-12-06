import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '733023707194-bnt5dj1dcqtvhdcg5g9hsq8j31qr6m7b.apps.googleusercontent.com',
    scopes: [
      'https://www.googleapis.com/auth/youtube.readonly',
      'https://www.googleapis.com/auth/youtube',
      'https://www.googleapis.com/auth/youtube.force-ssl'
    ],
  );
  late GoogleSignInAccount account;
  late GoogleSignInAuthentication auth;
   bool gotProfile = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return gotProfile
        ? Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                googleSignIn.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.network(
                  account.photoUrl!
              ),
              Text(account.displayName!),
              Text(account.email),
              Text('********************************'),
              Text('?? ${auth.serverAuthCode}'),
              RaisedButton(
                onPressed: () {
                  gogo();
                },
                child: Text('gogog'),
              ),
            ],
          ),
        ),
      ),
    )
        : const Scaffold(body: Center(child: SizedBox(width: 300, height: 200, child: CircularProgressIndicator())));
  }

  void getProfile() async {
    print('00000000000');
    account = (await googleSignIn.signIn())!;
    //googleSignIn.signIn();
    print('111111111111');
    auth = await account.authentication;
    print('3333333333333');
    Map map = await account.authHeaders;
    print('idToken?? ${map}');

    setState(() {
      gotProfile = true;
    });
  }

  void gogo() async {
    print('id??? ${account.id}');
    print('accessToken?? ${auth.accessToken}');
    print('serverAuthCode?? ${auth.serverAuthCode}');
    print('idToken?? ${auth.idToken}');
  }
}
