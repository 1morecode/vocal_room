import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/agora_user_model.dart';
import 'package:vocal/channel/pages/room/profile/user_profile_model_sheet.dart';
import 'package:vocal/channel/pages/room/util/room_state.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/model/user.dart';

class BroadCasterProfile extends StatefulWidget {
  final String userName;
  final FirebaseUserModel firebaseUserModel;

  const BroadCasterProfile({Key key, this.userName, this.firebaseUserModel})
      : super(key: key);

  @override
  _BroadCasterProfileState createState() => _BroadCasterProfileState();
}

class _BroadCasterProfileState extends State<BroadCasterProfile> {

  @override
  void initState() {
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
                        CupertinoButton(
                          padding: EdgeInsets.all(0),
                          onPressed: widget.userName != AuthUtil.firebaseAuth.currentUser.uid ?  () {
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
                            url:
                            "${widget.firebaseUserModel.picture}",
                            width: 75,
                            height: 75,
                          ),
                        ),
                        // buildNewBadge(true),
                        buildMuteBadge()
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
                          "  ${widget.firebaseUserModel.name.split(' ')[0]}",
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
        return new Container(
          alignment: Alignment.bottomCenter,
          child: new Container(
            height: 20,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                !widget.firebaseUserModel.isOnline
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5))),
            child: new Text(
              !roomState.memberList.contains(widget.userName) ? "OFFLINE" :
              widget.firebaseUserModel.isOnline ? "ONLINE" : "OFFLINE",
              style: TextStyle(
                  fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Widget buildMuteBadge() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Consumer<RoomState>(
        builder: (context, roomState, child) {
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
            child: !roomState.memberList.contains(widget.userName) ?
            Icon(Icons.mic_off_outlined, size: 20,)
            : Icon(widget.firebaseUserModel.isMuted
                ? Icons.mic_off_outlined
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
            '👑',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
    );
  }
}
