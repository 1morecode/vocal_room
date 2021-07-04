
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/channel/pages/home/home_page.dart';
import 'package:vocal/channel/pages/room/call_screen.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/user_token.dart';

class UniLinkUtil{
  static String uniLinkResp;
  static Room room;

  static navigateAccordingToUniLink(context){
    List<String> uniLinkList = uniLinkResp.split(":").toList();
    print("uniLinkList $uniLinkList");

    if(uniLinkList.length > 0){
      if(uniLinkList[0] == "room"){
        _onJoinRoom(uniLinkList[1], context);
      }
    }else{
      print("List is empty");
    }
    uniLinkResp = null;
  }

  static _onJoinRoom(String roomId, context) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firebaseFirestore.collection('rooms').doc(roomId).get();
    room = Room.fromJson(documentSnapshot.data());
    bool isCreator = room.createdBy ==
        AuthUtil.firebaseAuth.currentUser.uid;
    if (isCreator) {
      int ind = room.users.indexWhere((element) => element["_id"] == room.createdBy);
      room.users[ind]["isMuted"] = true;
      room.users[ind]["isHandRaised"] = false;
      room.users[ind]["micOrHand"] = true;
      room.users[ind]["isOnline"] = true;
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('rooms')
          .doc(room.roomId);
      print("Users ${room.users}");
      messageDoc.update({
        'users': room.users,
      });
      enterRoom(context);
    } else {
      List<String> followersList = await UserToken.getUserFollowersByUId(
          room.createdBy);
      print("Foloowss $followersList");
      for (var i = 0; i < room.users.length; i++) {
        if (room.users[i]["_id"] ==
            AuthUtil.firebaseAuth.currentUser.uid) {
          if(followersList.contains(AuthUtil.firebaseAuth.currentUser.uid)){
            room.users[i]["isModerator"] = true;
            room.users[i]["micOrHand"] = true;
            room.users[i]["isMuted"] = true;
            room.users[i]["isHandRaised"] = false;
            final DocumentReference messageDoc = FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.roomId);
            print("Users ${room.users}");
            messageDoc.update({
              'users': room.users,
            });
            enterRoom(context);
          }else{
            room.users[i]["isModerator"] = false;
            room.users[i]["micOrHand"] = false;
            room.users[i]["isMuted"] = true;
            room.users[i]["isHandRaised"] = false;
            final DocumentReference messageDoc = FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.roomId);
            print("Users ${room.users}");
            messageDoc.update({
              'users': room.users,
            });
            enterRoom(context);
          }
          break;
        } else if (room.users.length == i + 1) {
          FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
              id: AuthUtil.firebaseAuth.currentUser.uid,
              name: AuthUtil.firebaseAuth.currentUser.displayName,
              username: AuthUtil.firebaseAuth.currentUser.email,
              picture: AuthUtil.firebaseAuth.currentUser.photoURL,
              isHandRaised: false,
              isModerator: followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? true : false,
              isMuted: true,
              isOnline: true,
              isBlocked: false,
              micOrHand: followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? true : false
          );

          room.users.add(firebaseUserModel.toJson());
          final DocumentReference messageDoc = FirebaseFirestore.instance
              .collection('rooms')
              .doc(room.roomId);
          print("Users ${room.users}");
          messageDoc.update({
            'users': room.users,
          });
          enterRoom(context);
        }
      }
    }
  }

 static enterRoom(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (rc) {
        return CallScreen(
          channelName: room.title,
          roomId: room.roomId,
          userId: AuthUtil.firebaseAuth.currentUser.uid,
          role: ClientRole.Broadcaster,
          room: room,
        );
      },
    );
  }

}