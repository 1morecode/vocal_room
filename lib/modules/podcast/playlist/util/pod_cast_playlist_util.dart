import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class PodCastPlaylistUtil {
  static var status = false;

  static Future<List<PodCastPlaylistModel>> fetchAllPlaylistModel(context) async {
    print("DSDSDSDSD");
    final playlistState = Provider.of<PodCastState>(context, listen: false);
    List<PodCastPlaylistModel> playlistModelList = [];
    String token = await UserToken.getToken();

    try {
      var header = {'x-token': "$token"};

      var request = http.Request('GET', Uri.parse('${APIData.baseUrl}${APIData.fetchAllPodCastPlaylistAPI}'));

      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        print("DATA Playlist $data");

        var list = data['resp']['data']
            .map((result) => new PodCastPlaylistModel.fromJson(result))
            .toList();
        for (int b = 0; b < list.length; b++) {
          PodCastPlaylistModel playlistModel = list[b] as PodCastPlaylistModel;
          playlistModelList.add(playlistModel);
        }
        playlistState.updatePodCastPlaylist(playlistModelList);
        print("All Media Model_______$playlistModelList");
      } else {
        print("ERROR ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception $e");
    }
    return playlistModelList;
  }
}
