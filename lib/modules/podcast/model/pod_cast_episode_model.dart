
class PodCastEpisodeModel {
  String id, title, desc, tag, collection, playlistId, createdAt, uId;
  List<dynamic> audio;
  List<dynamic> graphic;
  bool deleted;

  PodCastEpisodeModel(
      this.id,
      this.title,
      this.desc,
      this.tag,
      this.collection,
      this.playlistId,
      this.createdAt,
      this.uId,
      this.audio,
      this.graphic,
      this.deleted);

  factory PodCastEpisodeModel.fromJson(Map<String, dynamic> json) {
    return new PodCastEpisodeModel(
      json['_id'],
      json['episode_title'],
      json['episode_desc'],
      json['tag'],
      json['collection'],
      json['playlist_id'],
      json['createdAt'],
      json['uid'],
      json['assets']['audio'],
      json['assets']['graphic'],
      json['deleted'],
    );
  }

  static List<PodCastEpisodeModel> episodesList = [
    PodCastEpisodeModel("1", "title", "desc", "tag", "collection", "playlistId", "createdAt", "uId", [], [], true),
    PodCastEpisodeModel("1", "title", "desc", "tag", "collection", "playlistId", "createdAt", "uId", [], [], true),
  ];
}
