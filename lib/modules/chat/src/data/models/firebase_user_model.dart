
class FirebaseUserModel {
  String id;
  String name;
  String picture;
  String userId;
  String email;
  bool emailVerified;
  String uId;

  List<dynamic> tokens;

  FirebaseUserModel(this.id, this.name, this.picture, this.userId, this.email,
      this.emailVerified, this.uId, this.tokens);

  FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    picture = json['picture'];
    userId = json['user_id'];
    email = json['email'];
    emailVerified = json['email_verified'];
    uId = json['uid'];
    tokens = json['tokens'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'picture': picture,
      'user_id': userId,
      'email': email,
      'email_verified': emailVerified,
      'uid': uId,
      'tokens': tokens,
    };
  }

  FirebaseUserModel.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    picture = json['picture'];
    userId = json['user_id'];
    email = json['email'];
    emailVerified = json['email_verified'];
    uId = json['uid'];
    tokens = json['tokens'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['picture'] = picture;
    map['user_id'] = userId;
    map['email'] = email;
    map['email_verified'] = emailVerified;
    map['uid'] = uId;
    map['tokens'] = tokens;
    return map;
  }

  @override
  String toString() {
    return '{"_id": "$id", "name": "$name", "picture": "$picture", "user_id": "$userId", "email": "$email", "email_verified": $emailVerified, "uId": "$uId", "tokens": $tokens}';

  }
}
