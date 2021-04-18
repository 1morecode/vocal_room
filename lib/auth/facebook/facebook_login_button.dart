import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/main/main_page.dart';
import 'package:vocal/res/global_data.dart';

class FacebookLoginButton extends StatefulWidget {
  @override
  _FacebookLoginButtonState createState() => _FacebookLoginButtonState();
}

class _FacebookLoginButtonState extends State<FacebookLoginButton> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialButton(
        height: 50,
        minWidth: size.width*0.4,
        child: new Row(
          children: [
            new Image.asset("assets/facebook.png", width: 24, height: 24,),
            new SizedBox(width: 10,),
            new Text("Facebook", style: TextStyle(fontSize: 20),)
          ],
        ),
        color: Colors.white,
        textColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () async {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: new Text("Processing"),
              content: Center(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new CircularProgressIndicator(),
              ),),
            ),
          );
          int ii = await AuthUtil.facebookSignIn();
          Navigator.of(context).pop();
          if (ii == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } else {
            GlobalData.showSnackBar(
                "Authentication Failed!", context, Colors.red);
          }
        });
  }
}
