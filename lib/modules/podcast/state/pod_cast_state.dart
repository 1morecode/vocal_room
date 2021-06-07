import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/stories/model/story_model.dart';

class PodCastState extends ChangeNotifier {

  // Playlist
  List<PodCastPlaylistModel> podCastPlaylistList;

  void updatePodCastPlaylist(List<PodCastPlaylistModel> playlist) {
    this.podCastPlaylistList = [];
    this.podCastPlaylistList = playlist;
    notifyListeners();
  }

  // Episodes
  List<PodCastEpisodeModel> episodeModelList;

  void updateEpisodeModalList(List<PodCastEpisodeModel> list) {
    episodeModelList = [];
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

  // Stories
   List<StoryModel> storiesList;
   int selectedStoryIndex;

  void updateSelectedStatusIndex(int i) {
    this.selectedStoryIndex = i;
    notifyListeners();
  }

  void updateStatusModalList(List<StoryModel> list) {
    storiesList = [];
    this.storiesList = list;
    notifyListeners();
  }

  // Categories
  List<CategoryModel> categoriesList;

  void updateCategoryModalList(List<CategoryModel> list) {
    categoriesList = [];
    this.categoriesList = list;
    notifyListeners();
  }
}
