import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return FutureBuilder<FirebaseUserModel>(
      future: UserToken.getUserByUId(widget.userName),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
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
                      url: snapshot.data.picture,
                      width: 75,
                      height: 75,
                    ),
                  ),
                  // buildNewBadge(true),
                  // buildMuteBadge(isMute),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // buildModeratorBadge(clientRole),
                  Text(
                    snapshot.data.name.split(' ')[0],
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
        } else {
          return new Container(
            height: 50,
          );
        }
      },
    );

    //   Column(
    //   children: [
    //     Container(
    //       width: MediaQuery.of(context).size.width * 0.2,
    //       decoration: BoxDecoration(
    //         color: widget.role == ClientRole.Audience ?  Colors.blueAccent : Colors.deepPurpleAccent,
    //         shape: BoxShape.circle,
    //         border: Border.all(
    //             color: Colors.green,
    //             width: 2
    //         ),
    //       ),
    //       child: Center(
    //         child: Padding(
    //           padding: const EdgeInsets.all(10),
    //           child: widget.role == ClientRole.Audience ?
    //           Icon(
    //               Icons.people,
    //               color: Colors.white
    //           )
    //               :
    //           Icon(
    //               Icons.person,
    //               color: Colors.white
    //           ),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     Text(widget.userName)
    //   ],
    // );
  }
}