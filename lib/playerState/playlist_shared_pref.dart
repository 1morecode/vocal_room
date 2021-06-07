
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_info/media_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/res/api_data.dart';

class PlaylistSharedPref{
  static String key = "episodes";
  static String keyEpisodePlay = "firstPlayId";
  static SharedPreferences _preferences;
  static List<MediaItem> episodesList = [];

  static saveFirstPlay(String url) async{
    await _initialPreferences();
    _preferences.setString(keyEpisodePlay, url);
  }

  static getFirstPlay() async{
    await _initialPreferences();
    return _preferences.getString(keyEpisodePlay);
  }

  static _initialPreferences() async {
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  static savePreferences(List<PodCastEpisodeModel> list)async {
    AudioPlayer audioPlayer = new AudioPlayer();
    var _items = [];
    for(var i = 0; i < list.length; i++){
      Duration duration = await audioPlayer.setUrl("${APIData.imageBaseUrl}${list[i].audio[0]['path']}");
      MediaItem mediaItem = MediaItem(
        id: "${APIData.imageBaseUrl}${list[i].audio[0]['path']}",
        album: "${list[i].title}",
        title: "${list[i].title}",
        artist: "${list[i].desc}",
        duration: Duration(milliseconds: duration.inMilliseconds),
        artUri:
        Uri.parse("${APIData.imageBaseUrl}${list[i].graphic[0]['path']}"),
      );
      _items.add(mediaItem);
    }
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
    print("JSON ENCODED 1$jsonEncoded");
    if(jsonEncoded?.isEmpty ?? true){
      episodesList = [];
    }else{
      episodesList = (json.decode(jsonEncoded)
      as List<dynamic>)
          .map<MediaItem>((item) => MediaItem.fromJson(item))
          .toList();
      print("Playlist new ${episodesList[1].id}");
    }
    return episodesList;

  }

  // List<MediaItem> get items {
  //   loadFromPreferences().then((value) {
  //     return value;
  //   });
  // }

}