
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/res/api_data.dart';

class PlaylistSharedPref{
  static String key = "episodes";
  static SharedPreferences _preferences;
  static List<MediaItem> episodesList = [];

  static _initialPreferences() async {
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  static savePreferences(List<PodCastEpisodeModel> list)async {
    final _items = List.generate(
        list.length,
            (index) => MediaItem(
          // This can be any unique id, but we use the audio URL for convenience.
          id: "${APIData.imageBaseUrl}${list[index].audio[0]['path']}",
          album: "${list[index].title}",
          title: "${list[index].title}",
          artist: "${list[index].desc}",
          // duration: Duration(milliseconds: 5739820),
          artUri:
          Uri.parse("${APIData.imageBaseUrl}${list[index].graphic[0]['path']}"),
        ));
    await _initialPreferences();
    String ee = json.encode(
        _items
            .map<Map<String, dynamic>>(
                (music) => music.toJson())
            .toList());
    await _preferences.setString(key, ee);
  }

  static Future<List<MediaItem>> loadFromPreferences() async {
    await _initialPreferences();
    String jsonEncoded = _preferences.getString(key);
    print("JSON ENCODED $jsonEncoded");
    if(jsonEncoded?.isEmpty ?? true){
      episodesList = [];
    }else{
      episodesList = (json.decode(jsonEncoded)
      as List<dynamic>)
          .map<MediaItem>((item) => MediaItem.fromJson(item))
          .toList();
      print("Playlist $episodesList");
    }
    return episodesList;

  }

  // List<MediaItem> get items {
  //   loadFromPreferences().then((value) {
  //     return value;
  //   });
  // }

}