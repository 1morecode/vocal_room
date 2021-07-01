import 'package:flutter/material.dart';

class FirebaseUserModel {
  String id;
  String name;
  String username;
  String picture;
  bool isOnline, isMuted, isHandRaised, isModerator, isBlocked, micOrHand;

  FirebaseUserModel({
    @required this.id,
    @required this.name,
    @required this.username,
    @required this.picture,
    @required this.isOnline,
    @required this.isMuted,
    @required this.isHandRaised,
    @required this.isModerator,
    @required this.isBlocked,
    @required this.micOrHand,
  });

  FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    picture = json['picture'];
    isOnline = json['isOnline'];
    isMuted = json['isMuted'];
    isHandRaised = json['isHandRaised'];
    isModerator = json['isModerator'];
    isBlocked = json['isBlocked'];
    micOrHand = json['micOrHand'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'picture': picture,
      'isOnline': isOnline,
      'isMuted': isMuted,
      'isHandRaised': isHandRaised,
      'isModerator': isModerator,
      'isBlocked': isBlocked,
      'micOrHand': micOrHand,
    };
  }

  // FirebaseUserModel.fromLocalDatabaseMap(Map<String, dynamic> json) {
  //   id = json['_id'];
  //   name = json['name'];
  //   username = json['username'];
  //   picture = json['picture'];
  // }
  //
  // Map<String, dynamic> toLocalDatabaseMap() {
  //   Map<String, dynamic> map = {};
  //   map['_id'] = id;
  //   map['name'] = name;
  //   map['username'] = username;
  //   map['picture'] = picture;
  //   return map;
  // }
  //
  // @override
  // String toString() {
  //   return '{"_id":"$id","name":"$name","username":"$username", "picture": "$picture"}';
  // }
}
