class PlaylistModel {
  String id,
      title,
      image,
      desc,
      collection,
      createdAt,
      uId;

  bool deleted;

  PlaylistModel(this.id, this.title, this.image, this.desc, this.collection,
      this.deleted, this.createdAt, this.uId);

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return new PlaylistModel(
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
}
