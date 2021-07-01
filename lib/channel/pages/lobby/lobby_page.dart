
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
                  left: 10,
                  right: 10,
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
        vertical: 5,
      ),
      child: ScheduleCard(),
    );
  }

  Widget buildRoomCard(Room room) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: RoomCard(
        room: room,
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

  // onTapPressed(Room rooms) async{
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   DocumentSnapshot documentSnapshot =
  //   await firebaseFirestore.collection('rooms').doc(rooms.roomId).get();
  //   Room room = Room.fromJson(documentSnapshot.data());
  //   bool isCreator = room.createdBy ==
  //       AuthUtil.firebaseAuth.currentUser.uid;
  //   if (isCreator) {
  //     int ind = room.users.indexWhere((element) => element["_id"] == rooms.createdBy);
  //     room.users[ind]["isMuted"] = true;
  //     room.users[ind]["isHandRaised"] = false;
  //     room.users[ind]["micOrHand"] = true;
  //     room.users[ind]["isOnline"] = true;
  //     final DocumentReference messageDoc = FirebaseFirestore.instance
  //         .collection('rooms')
  //         .doc(room.roomId);
  //     print("Users ${room.users}");
  //     messageDoc.update({
  //       'users': room.users,
  //     }).then((value) {
  //       enterRoom(room, ClientRole.Broadcaster);
  //     });
  //   } else {
  //     List<String> followersList = await UserToken.getUserFollowersByUId(
  //         room.createdBy);
  //     print("Foloowss $followersList");
  //     for (var i = 0; i < room.users.length; i++) {
  //       if (room.users[i]["_id"] ==
  //           AuthUtil.firebaseAuth.currentUser.uid) {
  //         if(followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) && room.users[i]["isModerator"]){
  //           enterRoom(room, ClientRole.Broadcaster);
  //         } else if(followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) && !room.users[i]["isModerator"]){
  //           room.users[i]["isModerator"] = true;
  //           room.users[i]["micOrHand"] = true;
  //           room.users[i]["isMuted"] = true;
  //           room.users[i]["isHandRaised"] = false;
  //           final DocumentReference messageDoc = FirebaseFirestore.instance
  //               .collection('rooms')
  //               .doc(room.roomId);
  //           print("Users ${room.users}");
  //           messageDoc.update({
  //             'users': room.users,
  //           }).then((value) {
  //             enterRoom(room, ClientRole.Broadcaster);
  //           });
  //         }else{
  //           room.users[i]["isModerator"] = false;
  //           room.users[i]["micOrHand"] = false;
  //           room.users[i]["isMuted"] = true;
  //           room.users[i]["isHandRaised"] = false;
  //           final DocumentReference messageDoc = FirebaseFirestore.instance
  //               .collection('rooms')
  //               .doc(room.roomId);
  //           print("Users ${room.users}");
  //           messageDoc.update({
  //             'users': room.users,
  //           }).then((value) {
  //             enterRoom(room, ClientRole.Broadcaster);
  //           });
  //         }
  //         break;
  //       } else if (room.users.length == i + 1) {
  //         FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
  //             id: AuthUtil.firebaseAuth.currentUser.uid,
  //             name: AuthUtil.firebaseAuth.currentUser.displayName,
  //             username: AuthUtil.firebaseAuth.currentUser.email,
  //             picture: AuthUtil.firebaseAuth.currentUser.photoURL,
  //             isHandRaised: false,
  //             isModerator: followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? true : false,
  //             isMuted: true,
  //             isOnline: true,
  //             isBlocked: false,
  //           micOrHand: followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? true : false
  //         );
  //
  //         room.users.add(firebaseUserModel.toJson());
  //         final DocumentReference messageDoc = FirebaseFirestore.instance
  //             .collection('rooms')
  //             .doc(room.roomId);
  //         print("Users ${room.users}");
  //         messageDoc.update({
  //           'users': room.users,
  //         }).then((value) {
  //           enterRoom(room, followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? ClientRole.Broadcaster : ClientRole.Audience);
  //         });
  //       }
  //     }
  //   }
  // }
}
