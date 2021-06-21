class UserModel {
  final String name;
  final String username;
  final String profileImage;
  final String lastAccessTime;
  final String followers;
  final String following;
  final bool isNewUser;

  UserModel({
    this.name,
    this.username,
    this.profileImage,
    this.followers,
    this.following,
    this.lastAccessTime,
    this.isNewUser,
  });

  factory UserModel.fromJson(json) {
    return UserModel(
      name: json['name'],
      username: json['username'],
      profileImage: json['profileImage'],
      lastAccessTime: json['lastAccessTime'],
      followers: json['followers'],
      following: json['following'],
      isNewUser: json['isNewUser'],
    );
  }

}
