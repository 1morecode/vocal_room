import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocal/auth/facebook/facebook_login_button.dart';
import 'package:vocal/auth/google/google_login_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: colorScheme.onPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/login_bg.png"),
          fit: BoxFit.cover,
        )),
        child: new Container(
          height: size.height,
          width: size.width,
          color: Colors.black.withOpacity(0.3),
          child: new SafeArea(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GoogleSignInButton(), FacebookLoginButton()],
                ),
              ),
              CupertinoButton(
                onPressed: (){},
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: EasyRichText(
                  "By Continue, to agree our\n"
                      "Terms & Conditions",
                  defaultStyle: TextStyle(color: Colors.white),
                  patternList: [
                    EasyRichTextPattern(
                      targetString: 'Terms',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                    EasyRichTextPattern(
                      targetString: 'Conditions',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
