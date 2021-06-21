
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/auth/login_page.dart';
import 'package:vocal/model/user.dart';

class AuthUtil {
  static var firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn googleLogin = GoogleSignIn();
  static FacebookLogin facebookLogin = FacebookLogin();

  static Future<int> googleSignIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();
      final googleAuth = await googleSignInAccount.authentication;
      final googleAuthCred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final user = await firebaseAuth.signInWithCredential(googleAuthCred);
      sharedPreferences.setString("loginType", "google");

      IdTokenResult ss = await firebaseAuth.currentUser.getIdTokenResult(true);
      String token = await FirebaseMessaging.instance.getToken();
      // User Create
      final QuerySnapshot result =
      await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.user.uid).get();
      print("RES 1 ${result.docs}");
      final List<DocumentSnapshot> documents = result.docs;
      print("RES 2 ${documents.length}");
      if (documents.length == 0) {
        print("RES 3 ${documents.length}");
        // Update data to server if new user
        FirebaseFirestore.instance.collection('allUsers').doc(user.user.uid).set({
          'nickname': user.user.displayName,
          'photoUrl': user.user.photoURL,
          'id': user.user.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
          'tokens': FieldValue.arrayUnion([token]),
          'x-token': FieldValue.arrayUnion([ss.token]),
        });
        print("RES 4 ${documents.length}");

        // Write data to local
        await sharedPreferences.setString('id', user.user.uid);
        await sharedPreferences.setString('nickname', user.user.displayName);
        await sharedPreferences.setString('photoUrl', user.user.photoURL);
      } else {
        // Write data to local
        await sharedPreferences.setString('id', documents[0].data()['id']);
        await sharedPreferences.setString('nickname', documents[0].data()['nickname']);
        await sharedPreferences.setString('photoUrl', documents[0].data()['photoUrl']);
        await sharedPreferences.setString('aboutMe', documents[0].data()['aboutMe']);
      }

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
      final accessToken = facebookLoginResult.accessToken.token;
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        final facebookAuthCred = FacebookAuthProvider.credential(accessToken);
        final user = await firebaseAuth.signInWithCredential(facebookAuthCred);
        print("User : " + user.user.displayName);
        sharedPreferences.setString("loginType", "facebook");
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

  static logout(context) {
    firebaseAuth.signOut();
    googleLogin.signOut();
    facebookLogin.logOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false);
  }

  static logoutWarningAlert(context, colorScheme) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: new Text(
          "Warning!",
          style: TextStyle(color: colorScheme.primary),
        ),
        message: new Text("You really want to logout from this device?"),
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

  static User getCurrentUser() {
    User user = firebaseAuth.currentUser;
    return user;
  }

}
