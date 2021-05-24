class StoryModel {
  String picture;
  String name;
  String email;
  List<Status> status;

  StoryModel({this.picture, this.name, this.email, this.status});

  StoryModel.fromJson(Map<String, dynamic> json) {
    picture = json['picture'];
    name = json['name'];
    email = json['email'];
    if (json['status'] != null) {
      status = [];
      json['status'].forEach((v) {
        status.add(new Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picture'] = this.picture;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.status != null) {
      data['status'] = this.status.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  String sId;
  String assetsUrl;
  String createdAt;
  int views;

  Status({this.sId, this.assetsUrl, this.createdAt, this.views});

  Status.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    assetsUrl = json['assets_url'];
    createdAt = json['createdAt'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['assets_url'] = this.assetsUrl;
    data['createdAt'] = this.createdAt;
    data['views'] = this.views;
    return data;
  }
}