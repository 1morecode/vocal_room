import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';
import 'package:vocal/stories/model/story_model.dart';

class StoryUtil {
  static Future<List<StoryModel>> fetchAllStoriesModel(context) async {
    List<StoryModel> storiesList = [];
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};
      print("STATUS URL ${APIData.baseUrl}${APIData.fetchAllStatusAPI}");

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.fetchAllStatusAPI}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("STATUS DD $data");
        var list = data['resp']['response']
            .map((result) => new StoryModel.fromJson(result))
            .toList();
        for (int b = 0; b < list.length; b++) {
          StoryModel storyModel = list[b] as StoryModel;
          storiesList.add(storyModel);
        }
      } else {
        print("ISE ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception $e");
    }
    return storiesList;
  }

  static Future<bool> updateStatusView(context, id) async {
    String token = await UserToken.getToken();

    try {
      Map payload = {"_id": "$id"};

      print("ID $id");

      var body = json.encode(payload);
      var url = '${APIData.baseUrl}${APIData.updateStatusViewAPI}&_id=status._id&update_view=true';
      print("DATA _url_ $url $body");
      var response = await http.post(
        Uri.parse(url),
        headers: {"x-token": "$token", "Content-Type": "application/json"},
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      print("DATAQ ${response.body}");
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        return data['resp']['success'];
      } else {
        return false;
      }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }
}
