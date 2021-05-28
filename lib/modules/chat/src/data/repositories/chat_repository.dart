import 'dart:convert';
import 'package:vocal/modules/chat/src/data/models/chat.dart';
import 'package:vocal/modules/chat/src/data/models/custom_error.dart';
import 'package:vocal/modules/chat/src/data/models/message.dart';
import 'package:vocal/modules/chat/src/utils/custom_http_client.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class ChatRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getMessages() async {
    String token = await UserToken.getToken();
    var header = {'x-token': "$token"};
    try {
      var response = await http.get(Uri.parse('${APIData.serverUrl}/message'), headers: header);
      final List<dynamic> chatsResponse = jsonDecode(response.body)['messages'];
      final List<Chat> chats =
          chatsResponse.map((json) {
          Map<String, dynamic> userJson = json['from'];
          final chat = Chat.fromJson({
            "_id": json['chatId'],
            "user": userJson,
          });
          Message message = Message.fromJson(json);
          chat.messages.add(message);
          return chat;
          }).toList();
          chats.forEach((chat) {

          });
      return chats;
    } catch (err) {
      print(err);
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> sendMessage(String message, String to) async {
    String token = await UserToken.getToken();
    var header = {'x-token': "$token"};
    try {
      var body = jsonEncode({'message': message, 'to': to});
      var response = await http.post(
        Uri.parse('${APIData.serverUrl}/message'),
        headers: header,
        body: body,
        // encoding: Encoding.getByName("utf-8"),
      );
      print("Res Chat ${jsonDecode(response.body)}");
      final dynamic messageResponse = jsonDecode(response.body)['message'];
      Message _message = Message.fromJson(messageResponse);
      return _message;
    } catch (err) {
      print("Exc Chat $err");
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> getChatByUsersIds(String userId) async {
    String token = await UserToken.getToken();
    var header = {'x-token': "$token"};
    try {
      var response = await http.get(Uri.parse('${APIData.serverUrl}/chats/user/$userId'), headers: header);
      final dynamic chatResponse = jsonDecode(response.body)['chat'];

      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> readChat(String chatId) async {
    String token = await UserToken.getToken();
    var header = {'x-token': "$token"};
    try {
      var response = await http.post(Uri.parse('${APIData.serverUrl}/chats/$chatId/read'), headers: header);
      final dynamic chatResponse = jsonDecode(response.body)['chat'];

      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await http.delete(Uri.parse('${APIData.serverUrl}/message/$messageId'));
    } catch (err) {
      print("Error $err");
    }
  }

}
