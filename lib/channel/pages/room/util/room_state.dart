import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/agora_user_model.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/api_data.dart';

class RoomState extends ChangeNotifier {

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Room room;

  getRoomDetails(roomId) async {
    DocumentSnapshot documentSnapshot =
    await firebaseFirestore.collection('rooms').doc(roomId).get();
    this.room = Room.fromJson(documentSnapshot.data());
    // notifyListeners();
  }

  updateRoom(Room room) {
    this.room = room;
    // notifyListeners();
  }

  List<String> memberList = [];

  updateMemberList() async {
    try {
      print("MEMBERS 1");
      var members = await this.agoraChannel.getMembers();
      print("MEMBERS 2 ${members.toList()}");
      memberList.clear();
      for (var u in members) {
        memberList.add(u.userId);
      }
      getRoomDetails(room.roomId);
      final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('rooms').doc(room.roomId);
      documentReference.update({
        'speakerCount': members.length,
      });
    } catch (e) {
      print("Member Exception $e");
    }
    print("Mem ${this.memberList}");
    notifyListeners();
  }

  Timer intervalManager;

  AgoraRtmClient agoraClient;

  createAgoraClient(String userId, String roomId, AgoraRtmClient agoraClient) {
    this.agoraClient = agoraClient;
    this.agoraClient.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        this.agoraClient.logout();
        notifyListeners();
      }
    };
    this.agoraClient.login(null, userId);
    print('Login success: ' + userId);
    notifyListeners();
  }

  AgoraRtmChannel agoraChannel;

  createAgoraChannel(String userId, String roomId,
      AgoraRtmChannel agoraChannel) async {
    print("AGORA CHANNEL $agoraChannel");
    print("AGORA CHANNEL name $roomId");
    this.agoraChannel = agoraChannel;
    this.agoraChannel.onMemberJoined = (AgoraRtmMember member) async {
      print('Member joined : ${member.userId}');
      await this.agoraClient.sendMessageToPeer(
          member.userId,
          AgoraRtmMessage.fromText('${member.userId}:join'));

      this.updateMemberList();
    };
    this.agoraChannel.onMemberLeft = (AgoraRtmMember member) async {
      print('Member left : ${member.userId}:leave');

      await this
          .agoraChannel
          .sendMessage(AgoraRtmMessage.fromText('${member.userId}:leave'));

      this.updateMemberList();
    };
    this.agoraChannel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) async {
      var messageList = message.text.split(':');
      print("Message $message");
      if(messageList.contains("mutedByAdmin")){
        if(messageList[0] == AuthUtil.firebaseAuth.currentUser.uid){
          if(messageList[2] == "true"){
            this.rtcEngine.muteLocalAudioStream(true);
          }else{
            this.rtcEngine.muteLocalAudioStream(false);
          }
        }
      }
      this.updateMemberList();
      print('Channel message received : ${message.text} from ${member.userId}');
    };

    await this.agoraChannel.join();
    print('RTM Join channel success.');
    var roleStr = this.clientRole == ClientRole.Broadcaster ? "mod" : "aud";
    await this
        .agoraChannel
        .sendMessage(AgoraRtmMessage.fromText('$userId:join:$roleStr'));
    await this.updateMemberList();
    notifyListeners();
  }

  RtcEngine rtcEngine;

  joinChannelWithUserAccount(String token, String channelId, String userId) {
    this.rtcEngine.joinChannelWithUserAccount(token, channelId, userId);
    notifyListeners();
  }

  initializeRtcEngine(RtcEngine rtcEngine, ClientRole clientRole) async {
    try {
      this.rtcEngine = rtcEngine;
      await this.rtcEngine.disableVideo();
      await this.rtcEngine.enableAudio();
      await this.rtcEngine.enableAudioVolumeIndication(500, 3, true);
      await this.rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await this.rtcEngine.setClientRole(clientRole);
      await this.rtcEngine.muteLocalAudioStream(true);
      this.clientRole = clientRole;
    } catch (e) {
      print("Engine Exception $e");
    }
    addAgoraEventHandlers();
    notifyListeners();
  }

  ClientRole clientRole = ClientRole.Audience;

  updateClientRole(ClientRole clientRole) {
    print("Client Role $clientRole");
    this.clientRole = clientRole;
    this.rtcEngine.setClientRole(clientRole);
    notifyListeners();
  }

  toggleClientRole({bool addToModerator = false}) async {
    print("DSDSDSD");
    // if (this.clientRole == ClientRole.Audience) {
    //   this.clientRole = ClientRole.Broadcaster;
    //   if (addToModerator) {
    //     // this.addModerator(AuthUtil.firebaseAuth.currentUser.uid);
    //     int userLength = this
    //         .moderators
    //         .where((element) =>
    //     element.id == AuthUtil.firebaseAuth.currentUser.uid)
    //         .length;
    //     if (userLength == 0) {
    //       AgoraUserModel agoraUserModel = new AgoraUserModel(
    //           "${AuthUtil.firebaseAuth.currentUser.uid}", true, false);
    //       allUsers.add(agoraUserModel);
    //     }
    //   }
    // } else {
    //   this.clientRole = ClientRole.Audience;
    //   int ind = this.moderators.indexWhere(
    //           (element) => element.id == AuthUtil.firebaseAuth.currentUser.uid);
    //   this.removeModerator(ind);
    // }
    // var roleStr = this.clientRole == ClientRole.Broadcaster ? "mod" : "aud";
    // await this.agoraChannel.sendMessage(AgoraRtmMessage.fromText(
    //     '${AuthUtil.firebaseAuth.currentUser.uid}:$roleStr'));
    // print("Client Role ${this.clientRole}");
    // print("Mem ${this.memberList}");
    // print("All ${this.allUsers}");
    // print("All ${this.moderators}");
    this.rtcEngine.setClientRole(this.clientRole);

    notifyListeners();
  }

  bool isMuted = true;

  toggleMute() async {
    int ind = room.users.indexWhere((element) =>
    element["_id"] == AuthUtil.firebaseAuth.currentUser.uid);
    this.rtcEngine?.muteLocalAudioStream(!room.users[ind]["isMuted"]);
    room.users[ind]["isMuted"] = !room.users[ind]["isMuted"];
    this.rtcEngine?.muteLocalAudioStream(room.users[ind]["isMuted"]);
    final DocumentReference messageDoc = FirebaseFirestore.instance
        .collection('rooms')
        .doc(room.roomId);
    print("Users ${room.users}");
    messageDoc.update({
      'users': room.users,
    });

    notifyListeners();
  }

  bool isHandRaise = false;

  toggleHandRaise() async {
    int ind = room.users.indexWhere((element) =>
    element["_id"] == AuthUtil.firebaseAuth.currentUser.uid);
    room.users[ind]["isHandRaised"] = !room.users[ind]["isHandRaised"];
    final DocumentReference messageDoc = FirebaseFirestore.instance
        .collection('rooms')
        .doc(room.roomId);
    print("Users ${room.users}");
    messageDoc.update({
      'users': room.users,
    });
    notifyListeners();
  }

  void disposeChannel() {
    print("Disposing");
    this.rtcEngine.leaveChannel();
    this.rtcEngine.destroy();
    this.agoraChannel.leave();
    this.room = null;
  }

  var _infoStrings = <String>[];

  List<String> speakersList = [];

  /// Add agora event handlers
  void addAgoraEventHandlers() {
    this.rtcEngine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        final info = 'onError: $code';
        _infoStrings.add(info);
      },
      userMuteAudio: (uid, muted) {
        print("Handler User $uid Muted $muted");
      },
      joinChannelSuccess: (channel, uid, elapsed) async {
        print("Handler Join Channel $uid");
      },
      leaveChannel: (stats) async {
        print("Handler User Leave $stats");
      },
      userJoined: (uid, elapsed) {
        print("Handler User Joined $uid");
      },
      userOffline: (uid, reason) {
        print("Handler User Offline $uid");
      },
      activeSpeaker: (uid) {

      },
      audioVolumeIndication: (List<AudioVolumeInfo> speakers, totalVolume) async{
        print("Speakers ${speakers.length}, Total Val $totalVolume");
        speakersList.clear();
        for(var i in speakers) {
          if(i.uid == 0){
            if(i.volume > 5){
              speakersList.add(AuthUtil.firebaseAuth.currentUser.uid);
            }
          }else{
            if(i.volume > 5){
              UserInfo userInfo = await rtcEngine.getUserInfoByUid(i.uid);
              speakersList.add(userInfo.userAccount);
            }
          }
        }
        notifyListeners();
        print("Speakers List $speakersList");
      },
    ));
  }

  muteById(String id, bool muted) async{
    int ind = room.users.indexWhere((element) =>
    element["_id"] == id);
    room.users[ind]["micOrHand"] = !muted;
    room.users[ind]["isMuted"] = false;
    room.users[ind]["idHandRaised"] = false;
    final DocumentReference messageDoc = FirebaseFirestore.instance
        .collection('rooms')
        .doc(room.roomId);
    print("Users ${room.users}");
    messageDoc.update({
      'users': room.users,
    });
    await this.agoraChannel.sendMessage(AgoraRtmMessage.fromText(
        '$id:mutedByAdmin:$muted'));
  }
}
