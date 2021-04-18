
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocal/auth/login_page.dart';

class AuthUtil{
  static var firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn googleLogin = GoogleSignIn();
  static FacebookLogin facebookLogin = FacebookLogin();

  static Future<int> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();
      final googleAuth = await googleSignInAccount.authentication;
      final googleAuthCred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final user = await firebaseAuth.signInWithCredential(googleAuthCred);
      print("User : " + user.user.displayName);
      return 1;
    } catch (error) {
      return 0;
    }
  }

  static Future<GoogleSignInAccount> _handleGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }


  static Future<int> facebookSignIn() async {
    try {
      FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
      final accessToken = facebookLoginResult.accessToken.token;
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        final facebookAuthCred = FacebookAuthProvider.credential(accessToken);
        final user = await firebaseAuth.signInWithCredential(facebookAuthCred);
        print("User : " + user.user.displayName);
        return 1;
      } else {
        return 0;
      }
    } catch (error) {
      return 0;
    }
  }

  static Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  static logout(context){
    firebaseAuth.signOut();
    googleLogin.signOut();
    facebookLogin.logOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);
  }

  static logoutWarningAlert(context, colorScheme){
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: new Text(
          "Warning!",
          style: TextStyle(color: colorScheme.primary),
        ),
        message: new Text(
            "You really want to logout from this device?"),
        actions: [
          CupertinoActionSheetAction(
            child: new Text("Yes"),
            onPressed: () {
              AuthUtil.logout(context);
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: new Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}