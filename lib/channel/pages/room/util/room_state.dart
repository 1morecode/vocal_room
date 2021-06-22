
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/res/api_data.dart';

class RoomState extends ChangeNotifier{
  List<String> moderators = [];

  updateModerators(List<String> users){
    this.moderators = users;
    notifyListeners();
  }

  removeModerator(String moderator){
    this.moderators.remove(moderator);
    notifyListeners();
  }

  addModerator(String moderator){
    this.moderators.add(moderator);
    notifyListeners();
  }

  Map<String, String> allUsers = {};

  updateUsers(Map<String, String> users){
    this.allUsers = users;
    notifyListeners();
  }

  removeUsers(String user){
    this.allUsers.remove(user);
    notifyListeners();
  }

  addUsers(String user){
    this.allUsers.putIfAbsent(user, () => user);
    notifyListeners();
  }

  List<AgoraRtmMember> memberList = [];

  updateMemberList(List<AgoraRtmMember> members) {
    this.memberList = members;
    allUsers.clear();
    for (var u in memberList){
        allUsers.putIfAbsent(u.userId, () => u.userId);
    }
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

  createAgoraChannel(String userId, String roomId, AgoraRtmChannel agoraChannel) {
    this.agoraChannel = this.agoraChannel;
    this.agoraChannel.onMemberJoined = (AgoraRtmMember member) {

      print('Member joined : ${member.userId}');
      print("GET MEmBER ${this.agoraChannel.getMembers()}");

      this.agoraClient.sendMessageToPeer(
          member.userId, AgoraRtmMessage.fromText('$userId:join'));
    };
    this.agoraChannel.onMemberLeft = (AgoraRtmMember member) {
      var reversedMap = this.allUsers.map((k, v) => MapEntry(v, k));
      print('Member left : ${member.userId}:leave');
      print('Member left : ${reversedMap[member.userId]}:leave');

      this.agoraChannel.sendMessage(
          AgoraRtmMessage.fromText('${reversedMap[member.userId]}:leave'));
    };
    this.agoraChannel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      print('Channel message received : ${message.text} from ${member.userId}');
    };

    this.agoraChannel.join();
    print('RTM Join channel success.');
    this.agoraChannel.sendMessage(AgoraRtmMessage.fromText('$userId:join'));
    this.agoraChannel = agoraChannel;
    notifyListeners();
  }

  RtcEngine rtcEngine;

  joinChannelWithUserAccount(String token, String channelId, String userId ){
    this.rtcEngine.joinChannelWithUserAccount(token, channelId, userId);
    notifyListeners();
  }

  initializeRtcEngine() async {
    this.rtcEngine = await RtcEngine.create(APIData.agoraAppId);
    await this.rtcEngine.disableVideo();
    await this.rtcEngine.enableAudio();
    await this.rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await this.rtcEngine.setClientRole(clientRole);
    notifyListeners();
  }

  ClientRole clientRole = ClientRole.Audience;

  updateClientRole(ClientRole clientRole){
    this.clientRole = clientRole;
    this.rtcEngine.setClientRole(this.clientRole);
    notifyListeners();
  }

  toggleClientRole(){
    if (this.clientRole == ClientRole.Audience) {
      this.clientRole = ClientRole.Broadcaster;
      this.addModerator(AuthUtil.firebaseAuth.currentUser.uid);
    } else {
      this.clientRole = ClientRole.Audience;
      this.removeModerator(AuthUtil.firebaseAuth.currentUser.uid);
    }
    this.rtcEngine?.setClientRole(this.clientRole);
    notifyListeners();
  }

  bool isMuted = true;

  toggleMute(){
    this.isMuted = !this.isMuted;
    this.rtcEngine?.muteLocalAudioStream(this.isMuted);
  }

}