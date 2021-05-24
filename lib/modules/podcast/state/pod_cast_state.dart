import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';

class PodCastState extends ChangeNotifier {
  List<PodCastPlaylistModel> podCastPlaylistList = [];

  void updatePodCastPlaylist(List<PodCastPlaylistModel> playlist) {
    this.podCastPlaylistList.clear();
    this.podCastPlaylistList = playlist;
    notifyListeners();
  }

  List<PodCastEpisodeModel> episodeModelList = [];

  void updateEpisodeModalList(List<PodCastEpisodeModel> list) {
    this.episodeModelList = list;
    notifyListeners();
  }

  void addEpisodeModal(PodCastEpisodeModel episodeModel) {
    this.episodeModelList.add(episodeModel);
    notifyListeners();
  }

  void removeEpisodeModal(PodCastEpisodeModel episodeModel) {
    this.episodeModelList.remove(episodeModel);
    notifyListeners();
  }
}
