import 'dart:convert';

import 'package:vocal/modules/chat/src/data/models/custom_error.dart';
import 'package:vocal/modules/chat/src/data/models/firebase_user_model.dart';
import 'package:vocal/modules/chat/src/data/models/user.dart';
import 'package:vocal/modules/chat/src/utils/custom_http_client.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class UserRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getUsers() async {
    List<UserModel> users = [];
    String token = await UserToken.getToken();
    var header = {'x-token': "$token"};
    try {
      var response = await http.get(Uri.parse('${APIData.baseUrl}${APIData.searchAllUsersAPI}'), headers: header);
      print("Resp ${jsonDecode(response.body)}");
      final List<dynamic> usersResponse = jsonDecode(response.body)['resp']['response'];
      final List<FirebaseUserModel> firebaseUsers =
          usersResponse.map((user) => FirebaseUserModel.fromJson(user)).toList();

      for(var i = 0; i < firebaseUsers.length; i++ ){
        UserModel userModel = UserModel(id: "${firebaseUsers[i].id}", name: "${firebaseUsers[i].name}", username: "${firebaseUsers[i].userId}", picture: "${firebaseUsers[i].picture}", chatId: "${firebaseUsers[i].id}");
        users.add(userModel);
      }
      print("Users $users");
      return users;
    } catch (err) {
      print("Exc $err");
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  // Future<void> saveUserFcmToken(String fcmToken) async {
  //   try {
  //     var body = jsonEncode({'fcmToken': fcmToken});
  //     await http.post(Uri.parse('${MyUrls.serverUrl}/fcm-token'), body: body);
  //   } catch (err) {
  //     print("error $err");
  //   }
  // }
}
