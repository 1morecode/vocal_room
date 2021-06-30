import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/agora_user_model.dart';
import 'package:vocal/channel/pages/home/profile_page.dart';
import 'package:vocal/channel/pages/room/util/room_state.dart';
import 'package:vocal/channel/pages/room/widgets/broadcaster_profile.dart';
import 'package:vocal/channel/pages/room/widgets/room_user.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_button.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/res/api_data.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String userId;
  final String roomId;
  final ClientRole role;

  CallScreen({this.channelName, this.userId, this.roomId, this.role});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  Timer intervalManager;
  Future<bool> initRoomFuture;
  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);

  @override
  void dispose() {
    var roomState = Provider.of<RoomState>(context, listen: false);
    roomState.allUsers.clear();
    roomState.moderators.clear();
    roomState.rtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    initRoomFuture = initialize();
    super.initState();
  }

  Future<bool> initialize() async {
    print("Role ${widget.role}");
    var roomState = Provider.of<RoomState>(context, listen: false);
    try {
      await roomState.getRoomDetails(widget.roomId);
      var rtcEngine = await RtcEngine.create(APIData.agoraAppId);
      await roomState.initializeRtcEngine(rtcEngine, widget.role);

      await roomState.joinChannelWithUserAccount(
          null, widget.roomId, AuthUtil.firebaseAuth.currentUser.uid);
      var rtcClient = await AgoraRtmClient.createInstance(APIData.agoraAppId);
      await roomState.createAgoraClient(
          widget.userId, widget.roomId, rtcClient);
      var channel = await roomState.agoraClient.createChannel(widget.roomId);
      await roomState.createAgoraChannel(widget.userId, widget.roomId, channel);
      AgoraUserModel agoraUserModel = roomState.moderators.firstWhere((element) => element.id == AuthUtil.firebaseAuth.currentUser.uid, orElse: () => null);
      if (widget.role == ClientRole.Broadcaster && agoraUserModel == null){
        AgoraUserModel agoraUserModel = new AgoraUserModel("${AuthUtil.firebaseAuth.currentUser.uid}", true, false);
        roomState.addModerator(agoraUserModel);
      }
        // roomState.addModerator(AuthUtil.firebaseAuth.currentUser.uid);
    } catch (e) {
      print("Exception $e");
    }
    return true;
  }

  void _onCallEnd(BuildContext context) {
    var roomState = Provider.of<RoomState>(context, listen: false);
    roomState.disposeChannel();
    Navigator.pop(context);
  }

  toggleRole() {
    var roomState = Provider.of<RoomState>(context, listen: false);
    roomState.toggleClientRole();
  }

  // toggleMic() {
  //   var roomState = Provider.of<RoomState>(context, listen: false);
  //   roomState.toggleMute();
  // }

  Widget getMicButton() {
    return widget.role == ClientRole.Audience
        ? new Container()
        : Consumer<RoomState>(
            builder: (_, roomState, child) {
              return RoundButton(
                onPressed: () => roomState.toggleMute(),
                color: Style.LightGrey,
                isCircle: true,
                child: Icon(
                  roomState.isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.blueAccent,
                  size: 18.0,
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              '${widget.channelName}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
              },
              child: RoundImage(
                url: AuthUtil.firebaseAuth.currentUser.photoURL,
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.only(
          left: 0,
          right: 0,
          bottom: 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      bottom: 80,
                      top: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(widget.channelName),
                        SizedBox(
                          height: 15,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(12),
                        //   child: Text(
                        //     'Broadcaster',
                        //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        buildBroadcaster(),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Followed to Moderator',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ),
                        buildFollowers(),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Others in the room',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ),
                        buildAudience(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildBottom(context),
                  ),
                ],
              );
            } else {
              return new Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future: initRoomFuture,
        ),
      )),
    );
  }

  Widget buildFollowers() {
    return Consumer<RoomState>(
      builder: (_, roomState, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 120,
          ),
          itemCount: roomState.moderators.length,
          itemBuilder: (gc, index) {
            AgoraUserModel agoraUserModel = roomState.allUsers
                .firstWhere((element) => element.id == roomState.room.createdBy, orElse: () => null);
            return agoraUserModel != null
                ? Container()
                : UserView(
              role: ClientRole.Broadcaster,
              userName: roomState.moderators[index].id,
            );
          },
        );
      },
    );
  }

  Widget buildBroadcaster() {
    return Consumer<RoomState>(
      builder: (_, roomState, child) {
        return BroadCasterProfile(
          userName: roomState.room.createdBy,
          role: ClientRole.Broadcaster,
        );
      },
    );
  }

  Widget buildAudience() {
    return Consumer<RoomState>(
      builder: (_, roomState, child) {
        print("Length ${roomState.allUsers.length - roomState.moderators.length}");
        return GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 120,
          ),
          itemCount: roomState.allUsers.length - roomState.moderators.length,
          itemBuilder: (gc, index) {
            List<AgoraUserModel> diff = [];
            for(var i=0; i<roomState.allUsers.length; i++){
              AgoraUserModel agoraUserModel = roomState.moderators.firstWhere((element) => element.id == roomState.allUsers[i].id, orElse: () => null);
              if(agoraUserModel == null && roomState.allUsers[i].id != roomState.room.createdBy){
                diff.add(roomState.allUsers[i]);
              }
            }
            // List<AgoraUserModel> diff = roomState.allUsers.toSet().difference(roomState.moderators.toSet()).toList();

            AgoraUserModel agoraUserModel = roomState.allUsers
                .firstWhere((element) => element.id == roomState.room.createdBy, orElse: () => null);
            return agoraUserModel != null
                ? Container()
                : UserView(
              role: ClientRole.Audience,
              userName: diff[index].id,
            );
          },
        );
      },
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Row(
                children: [
                  new Icon(
                    Icons.mic_external_on,
                    size: 14,
                  ),
                  // Text(
                  //   " ${widget.room.users.where((element) => element['_id'] == widget.room.createdBy).first['name']}",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 12,
                  //   ),
                  // ),
                  Consumer<RoomState>(builder: (context, roomState, child) => Text(
                    "  ${roomState.room.users.where((element) => element["_id"] == roomState.room.createdBy).first["name"]}",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),)
                ],
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
          Container(
            child: IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    // var roomState = Provider.of<RoomState>(context, listen: false);
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Style.LightBrown,
      borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
      //     gradient: LinearGradient(
      //   begin: Alignment.topRight,
      //   end: Alignment.bottomLeft,
      //   colors: [
      //     Colors.blue,
      //     Colors.red,
      //   ],
      // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundButton(
            onPressed: () => _onCallEnd(context),
            color: Style.LightGrey,
            child: Text(
              '✌️ Leave quietly',
              style: TextStyle(
                color: Style.AccentRed,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          getMicButton(),
          // Consumer<RoomState>(
          //   builder: (_, roomState, child) {
          //     return RoundButton(
          //       onPressed: toggleRole,
          //       color: Style.LightGrey,
          //       isCircle: true,
          //       child: Icon(
          //         roomState.clientRole == ClientRole.Broadcaster
          //             ? CupertinoIcons.minus
          //             : CupertinoIcons.add,
          //         size: 15,
          //         color: Colors.black,
          //       ),
          //     );
          //   },
          // ),
          Consumer<RoomState>(
            builder: (_, roomState, child) {
              return roomState.clientRole == ClientRole.Audience ? RoundButton(
                onPressed: () => roomState.toggleHandRaise(),
                color: Style.LightGrey,
                isCircle: true,
                child: Icon(
                  roomState.isHandRaise ? CupertinoIcons.hand_raised_fill : CupertinoIcons.hand_raised,
                  size: 15,
                  color: Colors.black,
                ),
              ) : new Container();
            },
          ),
        ],
      ),
    );
  }
}
