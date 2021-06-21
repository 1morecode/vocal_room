import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocal/channel/models/user.dart';
import 'package:vocal/model/user.dart';

class Room {
  final String title;
  final String desc;
  final String roomId;
  final List<dynamic> users;
  final int speakerCount;
  final String createdBy;
  final int createdAt;

  Room({
    this.title,
    this.desc,
    this.roomId,
    this.speakerCount,
    this.users,
    this.createdBy,
    this.createdAt,
  });

  factory Room.fromJson(json) {
    return Room(
      title: json['title'],
      desc: json['desc'],
      roomId: json['roomId'],
      users: json['users'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] as int,
      speakerCount: json['speakerCount'] as int,
    );
  }
}
