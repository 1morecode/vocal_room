import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class CategoryUtil{
  static List<CategoryModel> categoryList = [];

  static Future<List<CategoryModel>> fetchAllCategoriesModel(context) async {
    final podcastState = Provider.of<PodCastState>(context, listen: false);
    String token = await UserToken.getToken();

    try {
      var headers = {'x-token': "$token"};
      print("STATUS URL ${APIData.baseUrl}${APIData.fetchAllCategoryListAPI}");

      var request = http.Request(
          'GET', Uri.parse('${APIData.baseUrl}${APIData.fetchAllCategoryListAPI}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("STATUS DD $data");
        var list = data['resp']['data']
            .map((result) => new CategoryModel.fromJson(result))
            .toList();
        categoryList.clear();
        for (int b = 0; b < list.length; b++) {
          CategoryModel storyModel = list[b] as CategoryModel;
          categoryList.add(storyModel);
        }
      } else {
        print("ISE ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception $e");
    }
    podcastState.updateCategoryModalList(categoryList);
    return categoryList;
  }

  static Future<List<PodCastPlaylistModel>> fetchAllPlaylistModelByCategory(context, id) async {
    print("DSDSDSDSD EE");
    List<PodCastPlaylistModel> playlistModelList = [];
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request('GET', Uri.parse('${APIData.baseUrl}${APIData.fetchAllPlaylistByCategoryAPI}$id'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());

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