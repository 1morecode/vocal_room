import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/pages/room/util/room_state.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/user_token.dart';

class UserView extends StatefulWidget {
  final String userName;
  final ClientRole role;

  const UserView({Key key, this.userName, this.role}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  ClientRole role;

  @override
  void initState() {
    role = widget.role;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomState>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      "${value.room.users.where((element) => element["_id"] == widget.userName).first["picture"]}",
                  width: 75,
                  height: 75,
                ),
              ),
              // buildNewBadge(true),
              widget.role == ClientRole.Broadcaster
                  ? buildMuteBadge(true)
                  : buildRaiseHand(true),
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
                "${value.room.users.where((element) => element["_id"] == widget.userName).first["name"].split(' ')[0]}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMuteBadge(bool isMute) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Consumer<RoomState>(
        builder: (context, roomState, child) => Container(
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
          child: Icon(widget.userName == AuthUtil.firebaseAuth.currentUser.uid
              ? roomState.isMuted
                  ? Icons.mic_off
                  : Icons.mic
              : roomState.allUsers
                      .firstWhere((element) => element.id == widget.userName)
                      .muted
                  ? Icons.mic_off
                  : Icons.mic, size: 20,),
        ),
      ),
    );
  }

  Widget buildRaiseHand(bool isHandRaise) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Consumer<RoomState>(
        builder: (context, roomState, child) => Container(
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
          child: Icon(widget.userName == AuthUtil.firebaseAuth.currentUser.uid
              ? roomState.isHandRaise
                  ? CupertinoIcons.hand_raised_fill
                  : CupertinoIcons.hand_raised
              : roomState.allUsers
                      .where((element) => element.id == widget.userName)
                      .first
                      .isHandRaise
                  ? CupertinoIcons.hand_raised_fill
                  : CupertinoIcons.hand_raised, size: 20,),
        ),
      ),
    );
  }

  Widget buildNewBadge() {
    return Consumer<RoomState>(
      builder: (context, roomState, child) => Text(
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
