
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/user.dart';
import 'package:vocal/channel/widgets/round_image.dart';

class HomeAppBar extends StatelessWidget {
  final Function onProfileTab;

  const HomeAppBar({Key key, this.onProfileTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: new Text("Chat Rooms", style: TextStyle(color: Colors.red),),
        ),
        Spacer(),
        Row(
          children: [
            // IconButton(
            //   onPressed: () {},
            //   iconSize: 30,
            //   icon: Icon(Icons.mail),
            // ),
            SizedBox(
              width: 10,
            ),
            // IconButton(
            //   onPressed: () {},
            //   iconSize: 30,
            //   icon: Icon(Icons.calendar_today),
            // ),
            SizedBox(
              width: 10,
            ),
            // IconButton(
            //   onPressed: () {},
            //   iconSize: 30,
            //   icon: Icon(Icons.notifications_active_outlined),
            // ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: onProfileTab,
              child: RoundImage(
                url: AuthUtil.firebaseAuth.currentUser.photoURL,
                width: 40,
                height: 40,
              ),
            )
          ],
        ),
      ],
    );
  }
}
