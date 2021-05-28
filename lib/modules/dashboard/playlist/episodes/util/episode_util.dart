import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class EpisodeUtil {
  static var status = false;

  static Future<bool> fetchAllEpisodeModel(context, id) async {
    final episodeState = Provider.of<PodCastState>(context, listen: false);

    String token = await UserToken.getToken();
print("id  $id");
    try {
      var headers = {'x-token': "$token"};

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.fetchPlaylistEpisodeAPI}?playlist_id=$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var data = jsonDecode(await response.stream.bytesToString());
      print("DATA E $data");
      if (response.statusCode == 200) {
        List<PodCastEpisodeModel> episodeModelList = [];
        var list = data['resp']['data']
            .map((result) => new PodCastEpisodeModel.fromJson(result))
            .toList();
        for (int b = 0; b < list.length; b++) {
          PodCastEpisodeModel episodeModel = list[b] as PodCastEpisodeModel;
          episodeModelList.add(episodeModel);
        }
        episodeState.updateEpisodeModalList(episodeModelList);
        print("All Media Model_______$episodeModelList");
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

  static Future<bool> deleteEpisodeModel(context, id) async {
    String token = await UserToken.getToken();

    try {
      Map payload = {"_id": "$id"};

      print("ID $id");

      var body = json.encode(payload);
      var url = '${APIData.baseUrl}${APIData.deleteEpisodeAPI}';
      print("DATA _url_ $url $body");
      var response = await http.post(
        Uri.parse(url),
        headers: {"x-token": "$token", "Content-Type": "application/json"},
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );

      print("DATAAAA ${response.body}");

      var data = await jsonDecode(response.body);
printWrapped("DDD $data");
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

