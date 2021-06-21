import 'package:flutter/material.dart';

class FirebaseUserModel {
  String id;
  String name;
  String username;
  String picture;
  String chatId;

  FirebaseUserModel({
    @required this.id,
    @required this.name,
    @required this.username,
    @required this.picture,
    this.chatId,
  });

  FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    picture = json['picture'];
    chatId = json['chatId'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'picture': picture,
    };
  }

  FirebaseUserModel.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    picture = json['picture'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['picture'] = picture;
    return map;
  }

  @override
  String toString() {
    return '{"_id":"$id","name":"$name","username":"$username", "picture": "$picture"}';
  }
}
