import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:vocal/modules/podcast/model/episodes_model.dart';

class PlaylistEntity {
  final String name;
  final String id;
  final bool isLocal;
  final List<String> episodeList;

  PlaylistEntity(this.name, this.id, this.isLocal, this.episodeList);

  Map<String, Object> toJson() {
    return {
      'name': name,
      'id': id,
      'isLocal': isLocal,
      'episodeList': episodeList
    };
  }

  static PlaylistEntity fromJson(Map<String, Object> json) {
    var list = List<String>.from(json['episodeList']);
    return PlaylistEntity(json['name'] as String, json['id'] as String,
        json['isLocal'] == null ? false : json['isLocal'] as bool, list);
  }
}

class Playlist extends Equatable {
  /// Playlist name. the default playlist is named "Playlist".
  final String name;

  /// Unique id for playlist.
  final String id;

  final bool isLocal;

  /// Episode url list for playlist.
  final List<String> episodeList;

  /// Eposides in playlist.
  final List<EpisodeBrief> episodes;

  bool get isEmpty => episodeList.isEmpty;

  bool get isNotEmpty => episodeList.isNotEmpty;

  int get length => episodeList.length;

  bool get isQueue => name == 'Queue';

  bool contains(EpisodeBrief episode) => episodes.contains(episode);

  Playlist(this.name,
      {String id,
        this.isLocal = false,
        List<String> episodeList,
        List<EpisodeBrief> episodes})
      : id = id ?? Uuid().v4(),
        assert(name != ''),
        episodeList = episodeList ?? [],
        episodes = episodes ?? [];

  PlaylistEntity toEntity() {
    return PlaylistEntity(name, id, isLocal, episodeList.toSet().toList());
  }

  static Playlist fromEntity(PlaylistEntity entity) {
    return Playlist(
      entity.name,
      id: entity.id,
      isLocal: entity.isLocal,
      episodeList: entity.episodeList,
    );
  }

  void addToPlayList(EpisodeBrief episodeBrief) {
    if (!episodes.contains(episodeBrief)) {
      episodes.add(episodeBrief);
      episodeList.add(episodeBrief.enclosureUrl);
    }
  }

  void addToPlayListAt(EpisodeBrief episodeBrief, int index,
      {bool existed = true}) {
    if (existed) {
      episodes.removeWhere((episode) => episode == episodeBrief);
      episodeList.removeWhere((url) => url == episodeBrief.enclosureUrl);
    }
    episodes.insert(index, episodeBrief);
    episodeList.insert(index, episodeBrief.enclosureUrl);
  }

  void updateEpisode(EpisodeBrief episode) {
    var index = episodes.indexOf(episode);
    if (index != -1) episodes[index] = episode;
  }

  void reorderPlaylist(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final episode = episodes.removeAt(oldIndex);
    episodes.insert(newIndex, episode);
    episodeList.removeAt(oldIndex);
    episodeList.insert(newIndex, episode.enclosureUrl);
  }

  void clear() {
    episodeList.clear();
    episodes.clear();
  }

  @override
  List<Object> get props => [id, name];
}
