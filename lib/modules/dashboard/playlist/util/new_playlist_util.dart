import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/res/user_token.dart';

class NewPlaylistUtil {
  static TextEditingController playlistNameController = TextEditingController();
  static TextEditingController playlistDescController = TextEditingController();
  static TextEditingController categoryController = TextEditingController();
  static CategoryModel selectedCategory;
  static var newPlaylistBannerPicker = ImagePicker();
  static TextEditingController tagController = TextEditingController();
  static List<String> tags = [];
  static File file;

  static Future<bool> createNewPlaylist(context, title, desc) async {
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};

      var request = http.MultipartRequest(
          'POST', Uri.parse('${APIData.baseUrl}${APIData.createPlaylistAPI}'));

      request.files.add(await http.MultipartFile.fromPath('file', file.path.toString()));
      request.fields['playlist_title'] = "$title";
      request.fields['playlist_desc'] = "$desc";
      request.fields['cat_id'] = "${selectedCategory.id}";

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
