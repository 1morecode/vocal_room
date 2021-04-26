import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocal/res/api_data.dart';

class UserToken{

  static Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    var firebaseAuth = FirebaseAuth.instance;
    IdTokenResult ss = await firebaseAuth.currentUser.getIdTokenResult(true);
    print("TT $token");
    String userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({
      'tokens': FieldValue.arrayUnion([token]),
      'x-token': FieldValue.arrayUnion([ss.token]),
    });
  }

  static Future<String> getToken() async {
    var firebaseAuth = FirebaseAuth.instance;
    IdTokenResult ss = await firebaseAuth.currentUser.getIdTokenResult(true);
    print("TT $ss");
    return ss.token;
  }

  static Future<bool> updateToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
    var firebaseAuth = FirebaseAuth.instance;
    IdTokenResult ss = await firebaseAuth.currentUser.getIdTokenResult(true);
    Map payload = {
      "token": "${ss.token}",
    };
    try {
      var url = '${APIData.tokenAPI}';
      print("DATA _url_ $url");
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: payload,
        encoding: Encoding.getByName("utf-8"),
      );

      print("Response ${response.body}");
      return true;
    } catch (e) {
      print("Exception ____ $e");
      return false;
    }
  }

}