class StoryModel {
  String uid;
  List<Status> status;
  String picture;
  String name;
  String email;

  StoryModel({this.uid, this.status, this.picture, this.name, this.email});

  StoryModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    if (json['status'] != null) {
      status = [];
      json['status'].forEach((v) {
        status.add(new Status.fromJson(v));
      });
    }
    picture = json['picture'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    if (this.status != null) {
      data['status'] = this.status.map((v) => v.toJson()).toList();
    }
    data['picture'] = this.picture;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class Status {
  String assets;
  String assetsId;
  List<String> viewsId;

  Status({this.assets, this.assetsId, this.viewsId});

  Status.fromJson(Map<String, dynamic> json) {
    assets = json['assets'];
    assetsId = json['assetsId'];
    viewsId = json['viewsId'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assets'] = this.assets;
    data['assetsId'] = this.assetsId;
    data['viewsId'] = this.viewsId;
    return data;
  }
}