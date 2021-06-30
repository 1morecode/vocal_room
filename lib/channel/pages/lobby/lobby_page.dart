
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/channel/pages/lobby/util/lobby_util.dart';
import 'package:vocal/channel/pages/lobby/widgets/lobby_bottom_sheet.dart';
import 'package:vocal/channel/pages/lobby/widgets/room_card.dart';
import 'package:vocal/channel/pages/lobby/widgets/schedule_card.dart';
import 'package:vocal/channel/pages/room/call_screen.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_button.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/user_token.dart';

class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    askPermissions([Permission.microphone, Permission.phone]);
    super.initState();
  }

  /// Asks for contact permission.
  Future<void> askPermissions(List<Permission> requestedPermission) async {
    // Check permission status
    for(var i in requestedPermission){
      PermissionStatus status = await i.status;
      // Request permission
      if (status != PermissionStatus.granted &&
          status != PermissionStatus.permanentlyDenied) {
        status = await i.request();
      }
    }
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: StreamBuilder<List<Room>>(
            initialData: [],
            stream: LobbyUtil.streamRooms(),
            builder: (context, snapshot) {
              return ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 80,
                  left: 20,
                  right: 20,
                ),
                itemBuilder: (lc, index) {
                  return buildRoomCard(snapshot.data[index]);
                },
                itemCount: snapshot.data.length,
              );
            },
          ),
          // child: ListView.builder(
          //   padding: const EdgeInsets.only(
          //     bottom: 80,
          //     left: 20,
          //     right: 20,
          //   ),
          //   itemBuilder: (lc, index) {
          //     // if (index == 0) {
          //     //   return buildScheduleCard();
          //     // }
          //
          //     return buildRoomCard(rooms[index]);
          //   },
          //   itemCount: rooms.length,
          // ),
        ),
        buildGradientContainer(),
        buildStartRoomButton(),
      ],
    );
  }

  Widget buildScheduleCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: ScheduleCard(),
    );
  }

  Widget buildRoomCard(Room room) {
    return GestureDetector(
      onTap: () async {
        FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
            id: AuthUtil.firebaseAuth.currentUser.uid,
            name: AuthUtil.firebaseAuth.currentUser.displayName,
            username: AuthUtil.firebaseAuth.currentUser.email,
            picture: AuthUtil.firebaseAuth.currentUser.photoURL);

        List<String> followersList = await UserToken.getUserFollowersByUId(
            room.createdBy);
        print("Foloowss $followersList");
        print("Foloowss ${followersList.contains(
            AuthUtil.firebaseAuth.currentUser.uid)}");

        bool isCreator = room.createdBy ==
            AuthUtil.firebaseAuth.currentUser.uid;

        if (isCreator) {
          enterRoom(room, ClientRole.Broadcaster);
        } else {
          if (followersList.contains(AuthUtil.firebaseAuth.currentUser.uid)) {
            enterRoom(room, ClientRole.Broadcaster);
          } else {
            for (var i = 0; i < room.users.length; i++) {
              if (room.users[i]["_id"] ==
                  AuthUtil.firebaseAuth.currentUser.uid) {
                enterRoom(room, ClientRole.Audience);
                break;
              } else if (room.users.length == i + 1) {
                room.users.add(firebaseUserModel.toJson());
                final DocumentReference messageDoc = FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(room.roomId);
                print("Users ${room.users}");
                messageDoc.update({
                  'users': room.users,
                }).then((value) {
                  enterRoom(room, ClientRole.Audience);
                });
              }
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: RoomCard(
          room: room,
        ),
      ),
    );
  }

  Widget buildGradientContainer() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Style.LightBrown.withOpacity(0.2),
              Style.LightBrown,
            ],
          )),
    );
  }

  Widget buildStartRoomButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: RoundButton(
          onPressed: () {
            showBottomSheet();
          },
          color: Style.AccentGreen,
          text: '+ Start a room'),
    );
  }

  enterRoom(Room room, ClientRole role) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (rc) {
        return CallScreen(
          channelName: room.title,
          roomId: room.roomId,
          userId: AuthUtil.firebaseAuth.currentUser.uid,
          role: role,
        );
      },
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          child: Wrap(
            children: [
              LobbyBottomSheet(enterRoom),
            ],
          ),
        );
      },
    );
  }
}
