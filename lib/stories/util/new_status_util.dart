import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class NewStatusUtil {

  static Future<bool> createNewStatus(context, file) async {
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};

      var request = http.MultipartRequest(
          'POST', Uri.parse('${APIData.baseUrl}${APIData.createNewStatusAPI}'));

      request.files.add(await http.MultipartFile.fromPath('file', file.path.toString()));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var data = jsonDecode(await response.stream.bytesToString());
      print("Status DATA $data");
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
