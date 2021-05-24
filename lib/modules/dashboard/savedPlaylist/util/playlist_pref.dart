import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';

class SavedPlaylistState extends ChangeNotifier {
  final String key = "playlists";
  SharedPreferences _preferences;
  List<PodCastPlaylistModel> playlists;

  List<PodCastPlaylistModel> get savedPlaylist => playlists;

  SavedPlaylistState() {
    playlists = [];
    _loadFromPreferences();
  }

  _initialPreferences() async {
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences()async {
    await _initialPreferences();
    String ee = json.encode(
        playlists
            .map<Map<String, dynamic>>(
                (music) => PodCastPlaylistModel.toMap(music))
            .toList());
    await _preferences.setString(key, ee);
    _loadFromPreferences();
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    String jsonEncoded = _preferences.getString(key);
    print("JSON ENCODED $jsonEncoded");
    if(jsonEncoded?.isEmpty ?? true){
      playlists = [];
    }else{
      playlists = (json.decode(jsonEncoded)
      as List<dynamic>)
          .map<PodCastPlaylistModel>((item) => PodCastPlaylistModel.fromJson(item))
          .toList();
      print("Playlist $playlists");
    }
    notifyListeners();
  }

  addNewPlaylist(PodCastPlaylistModel pList) {
    if(!playlists.contains(pList)){
      playlists.add(pList);
      _savePreferences();
    }else{
      _savePreferences();
    }
    notifyListeners();
  }

  removePlaylist() {
    _savePreferences();
    notifyListeners();
  }

}