import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: new AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: new Text("Support"),
      ),
      body: new Column(
        children: [
          new SizedBox(
            height: 25,
          ),
          new Container(),
          new Expanded(
            child: new Container(),
          ),
          new Container(
            height: 25,
            child: new Row(
              children: [
                new Expanded(
                  child: new Divider(
                    color: colorScheme.secondaryVariant,
                    thickness: 1,
                  ),
                ),
                new SizedBox(
                  width: 15,
                ),
                new Text("Follow Us On",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.secondaryVariant,
                        fontSize: 14)),
                new SizedBox(
                  width: 15,
                ),
                new Expanded(
                  child: new Divider(
                    color: colorScheme.secondaryVariant,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          new SizedBox(
            height: 15,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new CupertinoButton(
                child: new Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorScheme.onPrimary,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.facebookSquare,
                    color: colorScheme.onSecondary,
                    size: 24,
                  ),
                ),
                onPressed: () {
                  launch("https://facebook.com");
                },
                padding: EdgeInsets.all(0),
              ),
              new CupertinoButton(
                child: new Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorScheme.onPrimary,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.twitterSquare,
                    color: colorScheme.onSecondary,
                    size: 24,
                  ),
                ),
                onPressed: () {
                  launch("https://twitter.com");
                },
                padding: EdgeInsets.all(0),
              ),
              new CupertinoButton(
                child: new Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorScheme.onPrimary,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.instagramSquare,
                    color: colorScheme.onSecondary,
                    size: 24,
                  ),
                ),
                onPressed: () {
                  launch("https://instagram.com");
                },
                padding: EdgeInsets.all(0),
              ),
              new CupertinoButton(
                child: new Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorScheme.onPrimary,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.linkedin,
                    color: colorScheme.onSecondary,
                    size: 24,
                  ),
                ),
                onPressed: () {
                  launch("https://linkedin.com");
                },
                padding: EdgeInsets.all(0),
              ),
              new CupertinoButton(
                child: new Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorScheme.onPrimary,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.youtube,
                    color: colorScheme.onSecondary,
                    size: 24,
                  ),
                ),
                onPressed: () {
                  launch("https://youtube.com");
                },
                padding: EdgeInsets.all(0),
              ),
            ],
          ),
          new SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  getIconData(String name) {
    if (name == "facebook") {
      return FontAwesomeIcons.facebookSquare;
    } else if (name == "Instagram") {
      return FontAwesomeIcons.instagramSquare;
    } else if (name == "youtube") {
      return FontAwesomeIcons.youtubeSquare;
    } else if (name == "twitter") {
      return FontAwesomeIcons.twitterSquare;
    } else if (name == "linkedin") {
      return FontAwesomeIcons.linkedinIn;
    } else if (name == "website") {
      return FontAwesomeIcons.globe;
    } else {
      return FontAwesomeIcons.globe;
    }
  }

}
