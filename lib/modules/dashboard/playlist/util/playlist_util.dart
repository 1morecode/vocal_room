import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vocal/modules/dashboard/playlist/model/playlist_model.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_state.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/res/user_token.dart';

class PlaylistUtil {
  static var status = false;

  static Future<bool> fetchAllPlaylistModel(context) async {
    final playlistState = Provider.of<PlaylistState>(context, listen: false);

    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.fetchPlaylistAPI}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var data = jsonDecode(await response.stream.bytesToString());
      print("DATA $data");
      if (response.statusCode == 200) {
        List<PlaylistModel> playlistModelList = [];
        var list = data['resp']['data']
            .map((result) => new PlaylistModel.fromJson(result))
            .toList();
        for (int b = 0; b < list.length; b++) {
          PlaylistModel playlistModel = list[b] as PlaylistModel;
          playlistModelList.add(playlistModel);
        }
        playlistState.updatePlaylistModalList(playlistModelList);
        print("All Media Model_______$playlistModelList");
        return data["resp"]["success"];
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }

  static Future<bool> deletePlaylistModel(context, id) async {
    String token = await UserToken.getToken();

    try {
      Map payload = {"_id": "$id"};

      print("ID $id");

      var body = json.encode(payload);
      var url = '${APIData.baseUrl}${APIData.deletePlaylistAPI}';
      print("DATA _url_ $url $body");
      var response = await http.post(
        Uri.parse(url),
        headers: {"x-token": "$token", "Content-Type": "application/json"},
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );

      print("DATAQ ${response.body}");

      var data = await jsonDecode(response.body);
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

      if (response.statusCode == 200) {
        return data['resp']['success'];
      } else {
        return false;
      }

      // var headers = {'x-token': "$token", "content-type" : "application/x-www-form-urlencoded"};
      //
      // var request = http.Request(
      //     'POST', Uri.parse('${APIData.baseUrl}${APIData.deletePlaylistAPI}'));
      // request.bodyFields['_id'] = "$id";
      // request.headers.addAll(headers);
      //
      // http.StreamedResponse response = await request.send();
      //
      // var data = jsonDecode(await response.stream.bytesToString());
      // print("DATA ${jsonDecode(response.body)}");
      // if (response.statusCode == 200) {
      //   return data["resp"]["success"];
      // } else {
      //   print(response.reasonPhrase);
      //   return false;
      // }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
