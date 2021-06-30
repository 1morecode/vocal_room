import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/agora_user_model.dart';
import 'package:vocal/channel/pages/room/util/room_state.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_image.dart';

class BroadCasterProfile extends StatefulWidget {
  final String userName;
  final ClientRole role;

  const BroadCasterProfile({Key key, this.userName, this.role})
      : super(key: key);

  @override
  _BroadCasterProfileState createState() => _BroadCasterProfileState();
}

class _BroadCasterProfileState extends State<BroadCasterProfile> {
  ClientRole role;

  @override
  void initState() {
    role = widget.role;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery
          .of(context)
          .size
          .width * 0.5,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Style.LightBrown,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/moderator_bg.jpg"),
            fit: BoxFit.cover,
          )),
      child: Consumer<RoomState>(
        builder: (context, roomState, child) =>
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // History.pushPage(
                            //   context,
                            //   ProfilePage(
                            //     profile: user,
                            //   ),
                            // );
                          },
                          child: RoundImage(
                            url:
                            "${roomState.room.users
                                .where((element) =>
                            element["_id"] == widget.userName)
                                .first["picture"]}",
                            width: 75,
                            height: 75,
                          ),
                        ),
                        // buildNewBadge(true),
                        widget.role == ClientRole.Broadcaster
                            ? buildMuteBadge(true)
                            : new Container(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNewBadge(),
                        Text(
                          "  ${roomState.room.users
                              .where((element) =>
                          element["_id"] == widget.userName)
                              .first["name"].split(' ')[0]}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                getOnlineOffline(),
                new Container()
              ],
            ),
      ),
    );
  }

  getOnlineOffline() {
    return Consumer<RoomState>(
      builder: (context, roomState, child) {
        AgoraUserModel agoraUserModel = roomState.allUsers.firstWhere(
                (element) => element.id == roomState.room.createdBy,
            orElse: () => null);
        return new Container(
          alignment: Alignment.bottomCenter,
          child: new Container(
            height: 20,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                agoraUserModel == null
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5))),
            child: new Text(
              agoraUserModel == null ? "OFFLINE" : "ONLINE",
              style: TextStyle(
                  fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Widget buildMuteBadge(bool isMute) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Consumer<RoomState>(
        builder: (context, roomState, child) {
          AgoraUserModel agoraUserModel = roomState.allUsers.firstWhere(
                  (element) => element.id == roomState.room.createdBy,
              orElse: () => null);
          return Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: agoraUserModel == null ?
            Icon(Icons.mic_off, size: 20,)
            : Icon(widget.userName == AuthUtil.firebaseAuth.currentUser.uid
                ? roomState.isMuted
                ? Icons.mic_off
                : Icons.mic
                : roomState.allUsers
                .firstWhere((element) => element.id == widget.userName)
                .muted
                ? Icons.mic_off
                : Icons.mic, size: 20,),
          );
        }
      ),
    );
  }

  Widget buildNewBadge() {
    return Consumer<RoomState>(
      builder: (context, roomState, child) =>
          Text(
            roomState.room.createdBy == widget.userName
                ? '👑'
                : widget.role == ClientRole.Broadcaster
                ? '🤝'
                : '🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
    );
  }
}
