class ChatUser {
  ChatUser({
    this.id,
    this.name,
    this.image,
  });

  factory ChatUser.fromMap(Map<String, dynamic> data) {
    return ChatUser(
        id: data['id'], name: data['nickname'], image: data['photoUrl']);
  }

  final String id;
  final String name;
  final String image;
}
