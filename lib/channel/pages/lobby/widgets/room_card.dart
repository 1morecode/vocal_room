
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/channel/pages/room/call_screen.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/user_token.dart';

class RoomCard extends StatefulWidget {
  final Room room;

  const RoomCard({Key key, this.room}) : super(key: key);

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  List<String> followersList;

  @override
  void initState() {
    getFollowersList();
    super.initState();
  }

  getFollowersList() async{
    followersList = await UserToken.getUserFollowersByUId(
        widget.room.createdBy);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
        child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 1),
            )
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.room.title}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              buildProfileImages(),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUserList(),
                  SizedBox(
                    height: 5,
                  ),
                  buildRoomInfo(context),
                ],
              )),
            ],
          )
        ],
      ),
    ), onPressed: (){
      onTapPressed(widget.room, context);
    });
  }

  Widget buildProfileImages() {
    var len = widget.room.users.length > 3 ? 3 : widget.room.users.length;
    return Stack(
      children: List.generate(len, (index) => RoundImage(
        margin:  EdgeInsets.only(top: 15 * index + .0, left: 0),
        url: "${widget.room.users.reversed.toList()[index]['picture']}",
        borderRadius: 15,
        height: 30,
        width: 30,
      )),
    );
  }

  Widget buildUserList() {
    var len = widget.room.users.length > 3 ? 3 : widget.room.users.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < len; i++)
          Container(
            child: Row(
              children: [
                Text(
                  "${widget.room.users.reversed.toList()[i]["name"]}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                // Icon(
                //   Icons.chat,
                //   color: Colors.grey,
                //   size: 14,
                // ),
              ],
            ),
          )
      ],
    );
  }

  Widget buildRoomInfo(context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(
            '${widget.room.speakerCount}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Icon(
            Icons.supervisor_account,
            color: Colors.grey,
            size: 14,
          ),
          // Text(
          //   '  /  ',
          //   style: TextStyle(
          //     color: Colors.grey,
          //     fontSize: 10,
          //   ),
          // ),
          // Text(
          //   '${room.speakerCount}',
          //   style: TextStyle(
          //     color: Colors.grey,
          //   ),
          // ),
          // Icon(
          //   Icons.chat_bubble_rounded,
          //   color: Colors.grey,
          //   size: 14,
          // ),
          Spacer(),
          new Row(
            children: [
              new Icon(Icons.mic_external_on, size: 14,),
              Text(
                " ${widget.room.users.where((element) => element['_id'] == widget.room.createdBy).first['name']}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  onTapPressed(Room rooms, context) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firebaseFirestore.collection('rooms').doc(rooms.roomId).get();
    Room room = Room.fromJson(documentSnapshot.data());
    bool isCreator = room.createdBy ==
        AuthUtil.firebaseAuth.currentUser.uid;
    if (isCreator) {
      int ind = room.users.indexWhere((element) => element["_id"] == rooms.createdBy);
      room.users[ind]["isMuted"] = true;
      room.users[ind]["isHandRaised"] = false;
      room.users[ind]["micOrHand"] = true;
      room.users[ind]["isOnline"] = true;
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('rooms')
          .doc(room.roomId);
      print("Users ${room.users}");
      messageDoc.update({
        'users': room.users,
      }).then((value) {
        enterRoom(room, ClientRole.Broadcaster, context);
      });
    } else {
      print("Foloowss $followersList");
      for (var i = 0; i < room.users.length; i++) {
        if (room.users[i]["_id"] ==
            AuthUtil.firebaseAuth.currentUser.uid) {
          if(followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) && room.users[i]["isModerator"]){
            enterRoom(room, ClientRole.Broadcaster, context);
          } else if(followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) && !room.users[i]["isModerator"]){
            room.users[i]["isModerator"] = true;
            room.users[i]["micOrHand"] = true;
            room.users[i]["isMuted"] = true;
            room.users[i]["isHandRaised"] = false;
            final DocumentReference messageDoc = FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.roomId);
            print("Users ${room.users}");
            messageDoc.update({
              'users': room.users,
            }).then((value) {
              enterRoom(room, ClientRole.Broadcaster, context);
            });
          }else{
            room.users[i]["isModerator"] = false;
            room.users[i]["micOrHand"] = false;
            room.users[i]["isMuted"] = true;
            room.users[i]["isHandRaised"] = false;
            final DocumentReference messageDoc = FirebaseFirestore.instance
                .collection('rooms')
                .doc(room.roomId);
            print("Users ${room.users}");
            messageDoc.update({
              'users': room.users,
            }).then((value) {
              enterRoom(room, ClientRole.Broadcaster, context);
            });
          }
          break;
        } else if (room.users.length == i + 1) {
          FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
              id: AuthUtil.firebaseAuth.currentUser.uid,
              name: AuthUtil.firebaseAuth.currentUser.displayName,
              username: AuthUtil.firebaseAuth.currentUser.email,
              picture: AuthUtil.firebaseAuth.currentUser.photoURL,
              isHandRaised: false,
              isModerator: followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? true : false,
              isMuted: true,
              isOnline: true,
              isBlocked: false,
              micOrHand: followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? true : false
          );

          room.users.add(firebaseUserModel.toJson());
          final DocumentReference messageDoc = FirebaseFirestore.instance
              .collection('rooms')
              .doc(room.roomId);
          print("Users ${room.users}");
          messageDoc.update({
            'users': room.users,
          }).then((value) {
            enterRoom(room, followersList.contains(AuthUtil.firebaseAuth.currentUser.uid) ? ClientRole.Broadcaster : ClientRole.Broadcaster, context);
          });
        }
      }
    }
  }

  enterRoom(Room room, ClientRole role, context) {
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
}
