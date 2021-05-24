import 'dart:convert';

class PodCastPlaylistModel {
  String id, title, image, desc, collection, createdAt, uId;

  bool deleted;

  PodCastPlaylistModel(this.id, this.title, this.image, this.desc,
      this.collection, this.deleted, this.createdAt, this.uId);

  factory PodCastPlaylistModel.fromJson(Map<String, dynamic> json) {
    return new PodCastPlaylistModel(
      json['_id'],
      json['playlist_title'],
      json['file_url'],
      json['playlist_desc'],
      json['collection'],
      json['deleted'],
      json['createdAt'],
      json['uid'],
    );
  }

  static Map<String, dynamic> toMap(PodCastPlaylistModel music) => {
        "_id": music.id,
        "playlist_title": music.title,
        "file_url": music.image,
        "playlist_desc": music.desc,
        "collection": music.collection,
        "deleted": music.deleted,
        "createdAt": music.createdAt,
        "uid": music.uId,
      };

  String encode(List<PodCastPlaylistModel> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>(
                (music) => PodCastPlaylistModel.toMap(music))
            .toList(),
      );

  List<PodCastPlaylistModel> decode(String musics) => (json.decode(musics)
          as List<dynamic>)
      .map<PodCastPlaylistModel>((item) => PodCastPlaylistModel.fromJson(item))
      .toList();
}
