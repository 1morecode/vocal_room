import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/custom_shared_preferences.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/res/util/follow_unfollow_util.dart';
import 'package:vocal/res/widgets/bottom_loader.dart';

class FollowUnfollowButton extends StatefulWidget {
  final String uid;
  final Color btnColor;
  final TextStyle textStyle;
  final VoidCallback callback;

  FollowUnfollowButton({this.uid, this.btnColor, this.textStyle,  this.callback});

  @override
  _FollowUnfollowButtonState createState() => _FollowUnfollowButtonState();
}

class _FollowUnfollowButtonState extends State<FollowUnfollowButton> {
  bool followed = false;
  bool loading = false;

  @override
  void initState() {
    print("UU ${widget.uid}");
    checkFollowStatus();
    super.initState();
  }


  checkFollowStatus() async {
    if(AuthUtil.firebaseAuth.currentUser.uid != widget.uid){
      bool status = await FollowUnFollowUtil.getFollowStatus(context, widget.uid);
      setState(() {
        followed = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return CupertinoButton(
        minSize: 20,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        borderRadius: BorderRadius.circular(25),
        color:
            widget.btnColor != null ? widget.btnColor : colorScheme.secondary,
        child: new Text(
          followed ? "Unfollow" : "Follow",
          style: widget.textStyle != null
              ? widget.textStyle
              : TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
        ),
        onPressed: () async {
          if(AuthUtil.firebaseAuth.currentUser.uid != widget.uid){
            BottomLoader bl = new BottomLoader(context,
                showLogs: true,
                isDismissible: false,
                loader: CircularProgressIndicator(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: colorScheme.onSurface, width: 1)));
            bl.style(
              message: 'Please wait...',
              backgroundColor: colorScheme.onPrimary,
            );
            bl.display();
            if (!loading) {
              setState(() {
                loading = true;
              });
              if (followed) {
                setState(() {
                  followed = !followed;
                });
                await FollowUnFollowUtil.unfollowUser(context, widget.uid);
                if(widget.callback !=null){
                  widget.callback();
                }
              } else {
                setState(() {
                  followed = !followed;
                });
                await FollowUnFollowUtil.followUser(context, widget.uid);
                if(widget.callback !=null){
                  widget.callback();
                }
              }
              setState(() {
                loading = false;
              });
            }
            bl.close();
          }else{
            GlobalData.showSnackBar("You can't follow yourself!", context, Colors.red);
          }
        });
  }
}
