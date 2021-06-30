
import 'package:flutter/material.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/channel/widgets/round_image.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({Key key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            room.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
    );
  }

  Widget buildProfileImages() {
    var len = room.users.length > 3 ? 3 : room.users.length;
    return Stack(
      children: List.generate(len, (index) => RoundImage(
        margin:  EdgeInsets.only(top: 15 * index + .0, left: 25),
        url: room.users.reversed.toList()[index]['picture'],
        borderRadius: 15,
        height: 30,
        width: 30,
      )),
    );
  }

  Widget buildUserList() {
    var len = room.users.length > 3 ? 3 : room.users.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < len; i++)
          Container(
            child: Row(
              children: [
                Text(
                  room.users.reversed.toList()[i]["name"],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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
            '${room.speakerCount}',
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
                " ${room.users.where((element) => element['_id'] == room.createdBy).first['name']}",
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
}
