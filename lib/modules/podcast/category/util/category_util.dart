import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
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
        podcastState.updateCategoryModalList(categoryList);
      } else {
        print("ISE ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception $e");
    }
    return categoryList;
  }
}