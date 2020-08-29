import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_social_login/MobileLogInScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Bar"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              RaisedButton(
                child: Text('Google Sign In'),
                onPressed: () {
                  signInWithGoogle();
                },
              ),
              RaisedButton(
                child: Text('Facebook Sign In'),
                onPressed: () {
                  facebookLogin();
                },
              ),
              RaisedButton(
                  child: Text('Mobile Log In'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MobileLoginScreen()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    var result = await _auth.signInWithCredential(credential).then((value) {
      var user = value.user;

      debugPrint("name is ${user.displayName}");
      debugPrint("name is ${user.uid}");
      debugPrint("profile image${user.photoURL}");
    }).catchError((error) {
      error.toString();
    });

    return "pavel";
  }

  void facebookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        facebookResult(result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        debugPrint(result.errorMessage);
        break;
    }
  }

  void facebookResult(var token) async {
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final profile = json.decode(graphResponse.body);
    debugPrint(profile.toString());
  }
}
