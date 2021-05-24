import 'package:flutter/cupertino.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';

class PlaylistState extends ChangeNotifier {
  List<PodCastPlaylistModel> playlistModelList = [];

  void updatePlaylistModalList(List<PodCastPlaylistModel> list) {
    this.playlistModelList = list;
    notifyListeners();
  }

  void addPlaylistModal(PodCastPlaylistModel playlistModel) {
    this.playlistModelList.add(playlistModel);
    notifyListeners();
  }

  void removePlaylistModal(PodCastPlaylistModel playlistModel) {
    this.playlistModelList.remove(playlistModel);
    notifyListeners();
  }
}
