class BannerModel {
  String id,title, image;

  BannerModel(this.id, this.title, this.image);

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return new BannerModel(
        json['banner_slider_id'],
        json['frontend_master_id'],
        json['banner_title'],);
  }
}
