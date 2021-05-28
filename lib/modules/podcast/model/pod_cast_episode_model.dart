
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

  static Map<String, dynamic> toMap(PodCastEpisodeModel music) => {
    "_id": music.id,
    "episode_title": music.title,
    "episode_desc": music.desc,
    "tag": music.tag,
    "collection": music.collection,
    "playlist_id": music.playlistId,
    "createdAt": music.createdAt,
    "uid": music.uId,
    "audio": music.audio,
    "graphic": music.graphic,
    "deleted": music.deleted,
  };

  static List<PodCastEpisodeModel> episodesList = [
    PodCastEpisodeModel("1", "title", "desc", "tag", "collection", "playlistId", "createdAt", "uId", [], [], true),
  ];

  static printList() async{
    print("List Print ${episodesList.length}");
  }
}
