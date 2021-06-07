import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class UpdateEpisodeUtil {
  static TextEditingController episodeNameController = TextEditingController();
  static TextEditingController episodeDescController = TextEditingController();
  static TextEditingController episodeFile = TextEditingController();
  static var updateEpisodeBannerPicker = ImagePicker();
  static File file;

  static File media;

  static Future<bool> updateEpisode(context, id) async {
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};
      print("${APIData.baseUrl}${APIData.updateEpisodeAPI}");
      var request = http.MultipartRequest(
          'POST', Uri.parse('${APIData.baseUrl}${APIData.updateEpisodeAPI}'));
      request.fields.addAll({
        '_id': '$id',
        'episode_title': '${episodeNameController.text}',
        'episode_desc': '${episodeDescController.text}',
        'tag': 'Tag First'
      });
      if (file != null) {
        print("File ${file.path}");
        request.files
            .add(await http.MultipartFile.fromPath('graphic', '${file.path}'));
      }
      print("DDD");
      if (media != null) {
        print("File ${media.path}");
        request.files
            .add(await http.MultipartFile.fromPath('audio', '${media.path}'));
      }

      request.headers.addAll(headers);

      print("Req ${request.fields}");
      http.StreamedResponse response = await request.send();

      var data = jsonDecode(await response.stream.bytesToString());
      print("DATA $data");
      if (response.statusCode == 200 && data["resp"]["success"] == true) {
        return true;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }
}
