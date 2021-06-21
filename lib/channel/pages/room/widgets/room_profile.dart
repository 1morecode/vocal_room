
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_image.dart';

class RoomProfile extends StatelessWidget {
  final dynamic user;
  final double size;
  final bool isMute;
  final ClientRole clientRole;
  final RtcEngine rtcEngine;

  const RoomProfile(
      {Key key,
        this.user,
        this.size,
        this.isMute = false,
        this.clientRole = ClientRole.Audience, this.rtcEngine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                url: user['picture'],
                width: size,
                height: size,
              ),
            ),
            buildNewBadge(true),
            buildMuteBadge(isMute),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildModeratorBadge(clientRole),
            Text(
              user['name'].split(' ')[0],
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildModeratorBadge(ClientRole clientRole) {
    return clientRole == ClientRole.Broadcaster
        ? Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Style.AccentGreen,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(
        Icons.star,
        color: Colors.white,
        size: 12,
      ),
    )
        : Container();
  }

  Widget buildMuteBadge(bool isMute) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: isMute
          ? Container(
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
        child: Icon(Icons.mic_off),
      )
          : Container(),
    );
  }

  Widget buildNewBadge(bool isNewUser) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: isNewUser
          ? Container(
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
        child: Text(
          '🎉',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : Container(),
    );
  }
}
