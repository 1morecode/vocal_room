
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/channel/pages/room/room_page.dart';

import 'package:vocal/channel/util/data.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_button.dart';
import 'package:vocal/model/user.dart';

class LobbyBottomSheet extends StatefulWidget {
  final Function callback;

  LobbyBottomSheet(this.callback);

  @override
  _LobbyBottomSheetState createState() => _LobbyBottomSheetState();
}

class _LobbyBottomSheetState extends State<LobbyBottomSheet> {
  var selectedButtonIndex = 0;
  final _userNameController = TextEditingController();
  final _userNameformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        right: 20,
        left: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 10,
          //   ),
          //   alignment: Alignment.centerRight,
          //   child: Text(
          //     '+ Add a Topic',
          //     style: TextStyle(
          //       color: Style.AccentGreen,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     for (var i = 0, len = 2; i < len; i++)
          //       InkWell(
          //         borderRadius: BorderRadius.circular(15),
          //         onTap: () {
          //           setState(() {
          //             selectedButtonIndex = i;
          //           });
          //         },
          //         child: Ink(
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 20,
          //             vertical: 5,
          //           ),
          //           decoration: BoxDecoration(
          //               color: i == selectedButtonIndex
          //                   ? Style.SelectedItemGrey
          //                   : Colors.transparent,
          //               borderRadius: BorderRadius.circular(15),
          //               border: Border.all(
          //                 color: i == selectedButtonIndex
          //                     ? Style.SelectedItemBorderGrey
          //                     : Colors.transparent,
          //               )),
          //           child: Column(
          //             children: [
          //               Container(
          //                 padding: const EdgeInsets.only(bottom: 5),
          //                 child: RoundImage(
          //                   width: 80,
          //                   height: 80,
          //                   borderRadius: 20,
          //                   path: lobbyBottomSheets[i]['image'],
          //                 ),
          //               ),
          //               Text(
          //                 lobbyBottomSheets[i]['text'],
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
          new Container(
            child: Form(
              key: _userNameformKey,
              child: TextFormField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _userNameformKey.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    // setState(() {
                    //   onNextButtonClick = null;
                    // });
                  } else {
                    // setState(() {
                    //   onNextButtonClick = next;
                    // });
                  }
                  return null;
                },
                controller: _userNameController,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Room Name',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1,
            height: 10,
            indent: 20,
            endIndent: 20,
          ),
          Text(
            lobbyBottomSheets[selectedButtonIndex]['selectedMessage'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Builder(builder: (_context) => RoundButton(
            color: Style.AccentGreen,
            onPressed: (){
              Navigator.of(context).pop();
              onRoomCreate(_context);
            },
            text: '🎉 Let\'s go',
          ),)
        ],
      ),
    );
  }

  // enterRoom(Room room, context) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (rc) {
  //       return RoomPage(
  //         room: room,
  //       );
  //     },
  //   );
  // }

  void onRoomCreate(context) async {
    var roomId = await nanoid(10);
    User user = AuthUtil.firebaseAuth.currentUser;
    // type: 0 = text, 1 = image, 2 = sticker
    final DocumentReference messageDoc = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        messageDoc,
        {
          'title': _userNameController.text.trim(),
          'desc': "",
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'roomId': roomId,
          'users': [FirebaseUserModel(id: user.uid, name: user.displayName, username: user.email, picture: user.photoURL,
          isBlocked: false, isOnline: true, isMuted: true, isModerator: true, isHandRaised: false, micOrHand: true).toJson()],
          'createdBy': user.uid,
          'speakerCount': 1
        },
      );
    }).then((value) {
      var data = {
        'title': _userNameController.text.trim(),
        'desc': "",
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'roomId': roomId,
        'users': [FirebaseUserModel(id: user.uid, name: user.displayName, username: user.email, picture: user.photoURL,
            isBlocked: false, isOnline: true, isMuted: true, isModerator: true, isHandRaised: false, micOrHand: true).toJson()],
        'createdBy': user.uid,
        'speakerCount': 1
      };
      Room room = Room.fromJson(data);
      widget.callback(room, ClientRole.Broadcaster);
    });
  }
}
