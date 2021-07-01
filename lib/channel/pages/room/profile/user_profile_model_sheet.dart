
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
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/user_token.dart';
import 'package:vocal/res/widgets/follow_unfollow_btn.dart';


class UserProfileModelSheet extends StatefulWidget {
  final String userName;
  final FirebaseUserModel firebaseUserModel;

  const UserProfileModelSheet({Key key, this.userName, this.firebaseUserModel})
      : super(key: key);

  @override
  _UserProfileModelSheetState createState() => _UserProfileModelSheetState();
}

class _UserProfileModelSheetState extends State<UserProfileModelSheet> {

  Future<dynamic> followFuture;

  @override
  void initState() {
    followFuture = UserToken.getUserProfileByUId(widget.userName);
    super.initState();
  }

  refreshUserProfile(){
    followFuture = UserToken.getUserProfileByUId(widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
      ),
      padding: const EdgeInsets.only(
        top: 15,
        right: 15,
        left: 15,
        bottom: 15,
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(30),
          ),
        ),),
        Divider(
          thickness: 1,
          height: 25,
        ),
        RoundImage(
          url: "${widget.firebaseUserModel.picture}",
          width: 100,
          height: 100,
          borderRadius: 100,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "${widget.firebaseUserModel.name}",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "@${widget.firebaseUserModel.id}",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        new Container(
          height: 25,
          child: FutureBuilder(builder: (context, snapshot) {
            if(snapshot.hasData){
              print("SNAP ${snapshot.data}");
              // List<String> followers = [];
              // // if(snapshot.data["followers"] != null)
              // followers = (snapshot.data["followers"] as List<dynamic>).cast<String>();
              return Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: snapshot.data["followers"] == null ? "0" : "${snapshot.data["followers"].length}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(text: ' Followers', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),),
                      ],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: snapshot.data["following"] == null ? "0" : "${snapshot.data["following"].length}", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        TextSpan(text: ' Following', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),),
                      ],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  FollowUnfollowButton(uid: widget.userName, btnColor: Colors.blue, textStyle: TextStyle(color: Colors.white), callback: refreshUserProfile,)
                ],
              );
            }else{
              return new Container(
              );
            }
          },
            future: followFuture,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            dummyText,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
    );
  }

  Widget builderInviter() {
    return Row(
      children: [
        RoundImage(
          path: 'assets/images/puzzleleaf.png',
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Joined Mar 28, 2021'),
            SizedBox(height: 3,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Nominated by ',
                  ),
                  TextSpan(
                    text: 'Puzzleleaf',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
