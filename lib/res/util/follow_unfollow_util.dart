import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class FollowUnFollowUtil {
  static Future<bool> getFollowStatus(context, to) async {
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.getFollowStatusAPI}$to'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("Un-Follow Data Res $data");
        return data["success"];
      } else {
        print("ERROR ${await response.stream.bytesToString()}");
        return false;
      }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }

  static Future<bool> followUser(context, to) async {
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.followAPI}$to'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("Follow Data Res $data");
        return data["success"];
      } else {
        print("ERROR ${await response.stream.bytesToString()}");
        return false;
      }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }

  static Future<bool> unfollowUser(context, to) async {
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.unfollowAPI}$to'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("Un-Follow Data Res $data");
        return data["success"];
      } else {
        print("ERROR ${await response.stream.bytesToString()}");
        return false;
      }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }
}
