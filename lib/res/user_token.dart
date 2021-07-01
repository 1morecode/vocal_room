import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/api_data.dart';

class UserToken {
  static Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    var firebaseAuth = FirebaseAuth.instance;
    IdTokenResult ss = await firebaseAuth.currentUser.getIdTokenResult(true);
    print("TT $token");
    String userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
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
      "x-token": "${ss.token}",
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

  static Future<FirebaseUserModel> getUserByUId(uid) async {
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.getUserByUIdAPI}$uid'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("User Data Res $data");
        FirebaseUserModel userModel = FirebaseUserModel(
            id: "${data["resp"]["response"]["_id"]}",
            name: "${data["resp"]["response"]["name"]}",
            username: "${data["resp"]["response"]["user_id"]}",
            picture: "${data["resp"]["response"]["picture"]}");
        return userModel;
      } else {
        print("ERROR ${await response.stream.bytesToString()}");
        return null;
      }
    } catch (e) {
      print("Exception ____ $e");
      return null;
    }
  }

  static Future<List<String>> getUserFollowersByUId(uid) async {
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.getUserByUIdAPI}$uid'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());

        print("User Data Res ${data["resp"]["response"]["followers"]}");
        // FirebaseUserModel userModel = FirebaseUserModel(id: "${data["resp"]["response"]["_id"]}", name: "${data["resp"]["response"]["name"]}", username: "${data["resp"]["response"]["user_id"]}", picture: "${data["resp"]["response"]["picture"]}");
        if (data["resp"]["response"]["followers"] == null) {
          return [];
        } else {
          return (data["resp"]["response"]["followers"] as List<dynamic>)
              .cast<String>();
        }
      } else {
        print("ERROR ${await response.stream.bytesToString()}");
        return [];
      }
    } catch (e) {
      print("Exception ____ $e");
      return [];
    }
  }

  static Future<dynamic> getUserProfileByUId(uid) async {
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.getUserByUIdAPI}$uid'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());

        print("User Data Res ${data["resp"]["response"]}");
        // FirebaseUserModel userModel = FirebaseUserModel(id: "${data["resp"]["response"]["_id"]}", name: "${data["resp"]["response"]["name"]}", username: "${data["resp"]["response"]["user_id"]}", picture: "${data["resp"]["response"]["picture"]}");
        if (data["resp"]["response"] == null) {
          return [];
        } else {
          return data["resp"]["response"];
        }
      } else {
        print("ERROR ${await response.stream.bytesToString()}");
        return [];
      }
    } catch (e) {
      print("Exception ____ $e");
      return [];
    }
  }
}
