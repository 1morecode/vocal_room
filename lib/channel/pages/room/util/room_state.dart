import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/agora_user_model.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/res/api_data.dart';

class RoomState extends ChangeNotifier {
  // RoomState(){
  //   initRtcEngine();
  // }

  // initRtcEngine() async{
  //   this.rtcEngine = await RtcEngine.create(APIData.agoraAppId);
  //   print("RTC ${await rtcEngine.getCallId()}");
  // }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Room room;

  getRoomDetails(roomId) async {
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection('rooms').doc(roomId).get();
    this.room = Room.fromJson(documentSnapshot.data());
    notifyListeners();
  }

  List<AgoraUserModel> moderators = [];

  updateModerators(List<AgoraUserModel> users) {
    this.moderators = users;
    notifyListeners();
  }

  removeModerator(int index) {
    this.moderators.removeAt(index);
    notifyListeners();
  }

  addModerator(AgoraUserModel moderator) {
    this.moderators.add(moderator);
    notifyListeners();
  }

  List<AgoraUserModel> allUsers = [];

  updateUsers(List<AgoraUserModel> users) {
    this.allUsers = users;
    notifyListeners();
  }

  removeUsers(AgoraUserModel user) {
    this.allUsers.remove(user);
    notifyListeners();
  }

  addUsers(AgoraUserModel user) {
    if (!this.allUsers.contains(user)) this.allUsers.add(user);
    notifyListeners();
  }

  List<AgoraRtmMember> memberList = [];

  updateMemberList() async {
    try {
      print("MEMBERS 1");
      var members = await this.agoraChannel.getMembers();
      print("MEMBERS 2 ${members.toList()}");
      this.memberList = members;
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('rooms').doc(room.roomId);
      documentReference.update({
        'speakerCount': members.length,
      });
      // allUsers.clear();
      for (var u in memberList) {
        // if(!this.allUsers.contains(u.userId))
        //   this.allUsers.add(u.userId);
        AgoraUserModel agoraUserModel = this.allUsers.firstWhere(
            (element) => element.id == u.userId,
            orElse: () => null);
        if (agoraUserModel == null) {
          AgoraUserModel agoraUserModel =
              new AgoraUserModel("${u.userId}", true, false);
          allUsers.add(agoraUserModel);
        }
      }
    } catch (e) {
      print("Member Exception $e");
    }

    print("Mem ${this.memberList}");
    print("All ${this.allUsers}");
    // print("Moderator ${this.moderators[0].id}");
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

  createAgoraChannel(
      String userId, String roomId, AgoraRtmChannel agoraChannel) async {
    print("AGORA CHANNEL $agoraChannel");
    print("AGORA CHANNEL name $roomId");
    this.agoraChannel = agoraChannel;
    this.agoraChannel.onMemberJoined = (AgoraRtmMember member) async {
      print('Member joined : ${member.userId}');
      // print("GET MEmBER ${this.agoraChannel.getMembers()}");
      var roleStr = this.clientRole == ClientRole.Broadcaster ? "mod" : "aud";
      await this.agoraClient.sendMessageToPeer(
          member.userId, AgoraRtmMessage.fromText('${member.userId}:join:$roleStr'));

      this.updateMemberList();
    };
    this.agoraChannel.onMemberLeft = (AgoraRtmMember member) async {
      print('Member left : ${member.userId}:leave');

      // print("Users ${messageDoc.}");
      // .doc(roomId);
      // messageDoc.up

      await this
          .agoraChannel
          .sendMessage(AgoraRtmMessage.fromText('${member.userId}:leave'));

      this.updateMemberList();
    };
    this.agoraChannel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) async {
      var messageList = message.text.split(':');
      print("Message $message");
      if (messageList.contains("mod")) {
        // if(!moderators.contains(member.userId))
        // moderators.add(member.userId);
        AgoraUserModel agoraUserModel = this.moderators.firstWhere(
            (element) => element.id == member.userId,
            orElse: () => null);
        if (agoraUserModel == null) {
          AgoraUserModel agoraUserModel =
              new AgoraUserModel("${member.userId}", true, false);
          allUsers.add(agoraUserModel);
          moderators.add(agoraUserModel);
        }
      } else if (messageList.contains("aud")) {
        AgoraUserModel agoraUserModel = this.allUsers.firstWhere(
            (element) => element.id == member.userId,
            orElse: () => null);
        allUsers.remove(agoraUserModel);
        moderators.remove(agoraUserModel);
      } else if (messageList.contains("leave")) {
        allUsers.remove(member.userId);
        moderators.remove(member.userId);
      } else if (messageList.contains("muted")) {
        String muted = messageList.last;
        AgoraUserModel agoraUserModel = allUsers.firstWhere(
            (element) => element.id == member.userId,
            orElse: () => null);
        print("AGG ${agoraUserModel.muted}");
        if (muted == "true") {
          if (agoraUserModel != null) {
            AgoraUserModel agModerator = moderators.firstWhere(
                (element) => element.id == member.userId,
                orElse: () => null);
            allUsers
                .firstWhere((element) => element.id == member.userId,
                    orElse: () => null)
                .muted = true;
            if (agModerator != null) {
              moderators
                  .firstWhere((element) => element.id == member.userId,
                      orElse: () => null)
                  .muted = true;
            }
          }
        } else {
          if (agoraUserModel != null) {
            AgoraUserModel agModerator = moderators.firstWhere(
                (element) => element.id == member.userId,
                orElse: () => null);
            allUsers
                .firstWhere((element) => element.id == member.userId,
                    orElse: () => null)
                .muted = false;
            if (agModerator != null) {
              moderators
                  .firstWhere((element) => element.id == member.userId,
                      orElse: () => null)
                  .muted = false;
            }
          }
        }
        AgoraUserModel aa = allUsers.firstWhere(
            (element) => element.id == member.userId,
            orElse: () => null);
        print("AGG 2 ${aa.muted}");
      } else if (messageList.contains("hand")) {
        AgoraUserModel agoraUserModel = allUsers.firstWhere(
            (element) => element.id == member.userId,
            orElse: () => null);
        print("Raise ${agoraUserModel.isHandRaise}");
        String handRaise = messageList.last;
        if (handRaise == "true") {
          if (agoraUserModel != null) {
            AgoraUserModel agModerator = moderators.firstWhere(
                (element) => element.id == member.userId,
                orElse: () => null);
            allUsers
                .firstWhere((element) => element.id == member.userId,
                    orElse: () => null)
                .isHandRaise = true;
            if (agModerator != null) {
              moderators
                  .firstWhere((element) => element.id == member.userId,
                      orElse: () => null)
                  .isHandRaise = true;
            }
          }
        } else {
          if (agoraUserModel != null) {
            AgoraUserModel agModerator = moderators.firstWhere(
                (element) => element.id == member.userId,
                orElse: () => null);
            allUsers
                .firstWhere((element) => element.id == member.userId,
                    orElse: () => null)
                .isHandRaise = false;
            if (agModerator != null) {
              moderators
                  .firstWhere((element) => element.id == member.userId,
                      orElse: () => null)
                  .isHandRaise = false;
            }
          }
        }
      }
      this.updateMemberList();
//           final Query messageDoc = FirebaseFirestore.instance
//               .collection('rooms')
//               .where("roomId", isEqualTo: roomId);
// List<QuerySnapshot> ss = await messageDoc.snapshots().toList();
//           print("Query ${ss.first.docs}");
      // notifyListeners();
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
    if (this.clientRole == ClientRole.Audience) {
      this.clientRole = ClientRole.Broadcaster;
      if (addToModerator) {
        // this.addModerator(AuthUtil.firebaseAuth.currentUser.uid);
        int userLength = this
            .moderators
            .where((element) =>
                element.id == AuthUtil.firebaseAuth.currentUser.uid)
            .length;
        if (userLength == 0) {
          AgoraUserModel agoraUserModel = new AgoraUserModel(
              "${AuthUtil.firebaseAuth.currentUser.uid}", true, false);
          allUsers.add(agoraUserModel);
        }
      }
    } else {
      this.clientRole = ClientRole.Audience;
      int ind = this.moderators.indexWhere(
          (element) => element.id == AuthUtil.firebaseAuth.currentUser.uid);
      this.removeModerator(ind);
    }
    var roleStr = this.clientRole == ClientRole.Broadcaster ? "mod" : "aud";
    await this.agoraChannel.sendMessage(AgoraRtmMessage.fromText(
        '${AuthUtil.firebaseAuth.currentUser.uid}:$roleStr'));
    print("Client Role ${this.clientRole}");
    print("Mem ${this.memberList}");
    print("All ${this.allUsers}");
    print("All ${this.moderators}");
    this.rtcEngine.setClientRole(this.clientRole);

    notifyListeners();
  }

  bool isMuted = true;

  toggleMute() async {
    this.isMuted = !this.isMuted;
    print("Client Mute ${this.isMuted}");
    this.rtcEngine?.muteLocalAudioStream(this.isMuted);
    await this.agoraChannel.sendMessage(AgoraRtmMessage.fromText(
        '${AuthUtil.firebaseAuth.currentUser.uid}:muted:$isMuted'));
    notifyListeners();
  }

  bool isHandRaise = false;

  toggleHandRaise()  async{
    this.isHandRaise = !this.isHandRaise;
    print("Client Hand ${this.isHandRaise}");
    await this.agoraChannel.sendMessage(AgoraRtmMessage.fromText(
        '${AuthUtil.firebaseAuth.currentUser.uid}:hand:$isHandRaise'));
    notifyListeners();
  }

  void disposeChannel() {
    print("Disposing");
    this.rtcEngine.leaveChannel();
    // this.rtcEngine.destroy();
    this.agoraChannel.leave();
    this.allUsers.clear();
    this.moderators.clear();
    // notifyListeners();
  }

  var _infoStrings = <String>[];

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
            //   final info = 'onJoinChannel: $channel, uid: $uid';
            //   _infoStrings.add(info);
            //   // _allUsers.putIfAbsent(uid, () => widget.userName);
            //
            // if (this.clientRole == ClientRole.Broadcaster) {
            //     // _users.add(uid);
            // }
            print("Handler Join Channel $uid");
          },
          leaveChannel: (stats) async {
            // setState(() {
            //   _infoStrings.add('onLeaveChannel');
            //   _users.clear();
            //   _allUsers.remove(localUid);
            // });
            // await _channel.sendMessage(AgoraRtmMessage.fromText('$localUid:leave'));
            print("Handler User Leave $stats");
          },
          userJoined: (uid, elapsed) {
            // final info = 'userJoined: $uid';
            // _infoStrings.add(info);
            // _users.add(uid);
            print("Handler User Joined $uid");
          },
          userOffline: (uid, reason) {
            // final info = 'userOffline: $uid , reason: $reason';
            // _infoStrings.add(info);
            // _users.remove(uid);
            print("Handler User Offline $uid");
          },
      activeSpeaker: (uid) {

      },
        ));
  }
}
