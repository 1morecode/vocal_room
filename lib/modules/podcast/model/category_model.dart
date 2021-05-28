
class CategoryModel{
  String id,title, image;

  CategoryModel(this.id, this.title, this.image);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return new CategoryModel(
      json['_id'],
      json['category_title'],
      json['image'],);
  }

  Map<String, Object> toJson() {
    return {
      '_id': id,
      'category_title': title,
      'image': image
    };
  }
}