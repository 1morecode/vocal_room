import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class PlaylistSearchUtil {
  static FocusNode focusNode = FocusNode();
  static TextEditingController searchController = new TextEditingController();
  static List<PodCastPlaylistModel> playlistModelList = [];

  static Future<List<PodCastPlaylistModel>> searchPlaylistModel(
      context) async {
    print("DSDSDSDSD EE");
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request('GET', Uri.parse(
          '${APIData.baseUrl}${APIData.playlistSearchAPI}${searchController
              .text}'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        playlistModelList.clear();
        var list = data['resp']['data']
            .map((result) => new PodCastPlaylistModel.fromJson(result))
            .toList();
        for (int b = 0; b < list.length; b++) {
          PodCastPlaylistModel playlistModel = list[b] as PodCastPlaylistModel;
          print("All Media Model_______${playlistModel.uId}");
          playlistModelList.add(playlistModel);
        }
        print("All Media Model_______$playlistModelList");
      } else {
        print("ERROR ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception Ply $e");
    }
    return playlistModelList;
  }
}