import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/res/user_token.dart';

class UpdatePlaylistUtil {
  static TextEditingController playlistNameController = TextEditingController();
  static TextEditingController playlistDescController = TextEditingController();

  static var updatePlaylistBannerPicker = ImagePicker();
  static File file;

  static Future<bool> updatePlaylist(context, id) async {
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};

      var request = http.MultipartRequest('POST', Uri.parse('${APIData.baseUrl}${APIData.updatePlaylistAPI}'));
      request.fields.addAll({
        '_id': '$id',
        'playlist_title': '${playlistNameController.text}',
        'playlist_desc': '${playlistDescController.text}'
      });
      request.files.add(await http.MultipartFile.fromPath('file',  file.path.toString()));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var data = jsonDecode(await response.stream.bytesToString());
      print("DATA ${data["resp"]["success"]}");
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
