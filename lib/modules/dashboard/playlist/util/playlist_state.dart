import 'package:flutter/cupertino.dart';
import 'package:vocal/modules/dashboard/playlist/model/playlist_model.dart';

class PlaylistState extends ChangeNotifier {
  List<PlaylistModel> playlistModelList = [];

  void updatePlaylistModalList(List<PlaylistModel> list) {
    this.playlistModelList = list;
    notifyListeners();
  }

  void addPlaylistModal(PlaylistModel playlistModel) {
    this.playlistModelList.add(playlistModel);
    notifyListeners();
  }

  void removePlaylistModal(PlaylistModel playlistModel) {
    this.playlistModelList.remove(playlistModel);
    notifyListeners();
  }
}
