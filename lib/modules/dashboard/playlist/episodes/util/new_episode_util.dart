import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/res/user_token.dart';

class NewEpisodeUtil {
  static TextEditingController episodeNameController = TextEditingController();
  static TextEditingController episodeDescController = TextEditingController();
  static TextEditingController tagController = TextEditingController();
  static TextEditingController episodeFile = TextEditingController();
  static List<String> tags = [];
  static var newEpisodeBannerPicker = ImagePicker();
  static File file;

  static File media;

  static Future<bool> addNewEpisode(context, id) async {
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};

      var request = http.MultipartRequest('POST', Uri.parse('${APIData.baseUrl}${APIData.createNewEpisodeAPI}/$id/upload'));
      request.fields.addAll({
        '_id': '$id',
        'episode_title': '${episodeNameController.text}',
        'episode_desc': '${episodeDescController.text}',
        'tag': 'Tag First'
      });
      print("FILE ${file.path}");
      print("Media ${media.path}");
      request.files.add(await http.MultipartFile.fromPath('audio', '${media.path}'));
      request.files.add(await http.MultipartFile.fromPath('graphic', '${file.path}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var data = jsonDecode(await response.stream.bytesToString());
      print("Episode DATA $data");
      if (response.statusCode == 200) {
        return data['resp']['success'];
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
