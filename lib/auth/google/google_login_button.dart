import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/pages/home/home_page.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/unilinks/my_unilinks.dart';
import 'package:vocal/unilinks/util.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialButton(
        height: 50,
        minWidth: size.width * 0.4,
        child: new Row(
          children: [
            new Image.asset(
              "assets/google.png",
              width: 24,
              height: 24,
            ),
            new SizedBox(
              width: 15,
            ),
            new Text(
              "Google",
              style: TextStyle(fontSize: 20),
            )
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
              content: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
          );
          int ii = await AuthUtil.googleSignIn();
          Navigator.of(context).pop();
          if (ii == 1) {
            UniLinkUtil.uniLinkResp != null
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyUniLinkPage(),
                    ),
                    (route) => false)
                : Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(null),
                    ),
                    (route) => false);
          } else {
            GlobalData.showSnackBar(
                "Authentication Failed!", context, Colors.red);
          }
        });
  }
}
