import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/pages/room/profile/user_profile_model_sheet.dart';
import 'package:vocal/channel/pages/room/util/room_state.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/user_token.dart';

class UserView extends StatefulWidget {
  final String userName;
  final FirebaseUserModel firebaseUserModel;

  const UserView({Key key, this.userName, this.firebaseUserModel})
      : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
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
              CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: widget.userName != AuthUtil.firebaseAuth.currentUser.uid ? () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
                      ),
                      context: context,
                      builder: (rc) {
                        return UserProfileModelSheet(
                          firebaseUserModel: widget.firebaseUserModel,
                          userName: widget.userName,
                        );
                      });
                } : null,
                child: RoundImage(
                  url: "${widget.firebaseUserModel.picture}",
                  width: 75,
                  height: 75,
                ),
              ),
              widget.firebaseUserModel.micOrHand
                  ? buildMuteBadge()
                  : buildRaiseHand(),
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
                "${widget.firebaseUserModel.name.split(' ')[0]}",
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

  Widget buildMuteBadge() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Consumer<RoomState>(
          builder: (context, roomState, child) => CupertinoButton(
                padding: EdgeInsets.all(0),
                minSize: 25,
                onPressed: roomState.room.createdBy ==
                        AuthUtil.firebaseAuth.currentUser.uid
                    ? () {
                        roomState.muteById(widget.userName,
                            widget.firebaseUserModel.micOrHand);
                      }
                    : null,
                child: Container(
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
                  child: Icon(
                    widget.firebaseUserModel.isMuted
                        ? Icons.mic_off_outlined
                        : Icons.mic,
                    size: 20,
                  ),
                ),
              )),
    );
  }

  Widget buildRaiseHand() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Consumer<RoomState>(
        builder: (context, roomState, child) => new CupertinoButton(
          minSize: 25,
          padding: EdgeInsets.all(0),
          child: Container(
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
            child: Icon(
              widget.firebaseUserModel.isHandRaised
                  ? CupertinoIcons.hand_raised_fill
                  : CupertinoIcons.hand_raised,
              size: 20,
              color: Colors.black87,
            ),
          ),
          onPressed:
              roomState.room.createdBy == AuthUtil.firebaseAuth.currentUser.uid
                  ? () {
                      roomState.muteById(
                          widget.userName, widget.firebaseUserModel.micOrHand);
                    }
                  : null,
        ),
      ),
    );
  }

  Widget buildNewBadge() {
    return Consumer<RoomState>(
      builder: (context, roomState, child) => Text(
        roomState.room.createdBy == widget.userName
            ? '👑'
            : widget.firebaseUserModel.isModerator
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
