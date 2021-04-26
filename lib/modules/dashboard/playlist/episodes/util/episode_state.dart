
import 'package:flutter/cupertino.dart';
import 'package:vocal/modules/dashboard/playlist/model/episode_model.dart';

class EpisodeState extends ChangeNotifier {
  List<EpisodeModel> episodeModelList = [];

  void updateEpisodeModalList(List<EpisodeModel> list) {
    this.episodeModelList = list;
    notifyListeners();
  }

  void addEpisodeModal(EpisodeModel episodeModel) {
    this.episodeModelList.add(episodeModel);
    notifyListeners();
  }

  void removeEpisodeModal(EpisodeModel episodeModel) {
    this.episodeModelList.remove(episodeModel);
    notifyListeners();
  }
}
