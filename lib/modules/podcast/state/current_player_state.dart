
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vocal/modules/podcast/model/episode_model.dart';
import 'package:vocal/modules/podcast/model/playlist_model.dart';
import 'package:vocal/state/audio_state.dart';

class CurrentPlayerState extends ChangeNotifier{
  PlaylistEntity currentPlaylistModel;
  List<EpisodeModel> currentEpisodeModelList;
  EpisodeModel currentPlayingEpisodeModel;
  var playlist;

  void updateCurrentPlayingState(PlaylistEntity playlist, List<EpisodeModel> episodes, EpisodeModel currentEpisode) {
    this.currentPlaylistModel = playlist;
    this.currentEpisodeModelList = episodes;
    this.currentPlayingEpisodeModel = currentEpisode;
    notifyListeners();
  }

  void removePlayingState(){
    this.currentEpisodeModelList = [];
    this.currentPlayingEpisodeModel = null;
    this.currentPlaylistModel = null;
    notifyListeners();
  }

  // void updatePlaylist(List<EpisodeModel> episodes){
  //   this.playlist = ConcatenatingAudioSource(children: List.generate(episodes.length, (index) => AudioSource.uri(
  //     Uri.parse(
  //         "${episodes[index].url}"),
  //     tag: AudioMetadata(
  //       album: "${episodes[index].title}",
  //       title: "A Salute To Head-Scratching Science",
  //       artwork:
  //       "${episodes[index].banner}",
  //     ),
  //   ),));
  // }

}