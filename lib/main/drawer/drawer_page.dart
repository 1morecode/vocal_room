import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  EdgeInsets padding = EdgeInsets.symmetric(horizontal: 15, vertical: 12);
  var firebaseAuth = FirebaseAuth.instance;
  double contentSpacing = 15.0;

  double iconSize = 18;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: new Column(
          children: [
            new Expanded(child: ListView(
              children: [
                new SizedBox(
                  height: size.height * 0.03,
                ),
                new Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: new Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.onPrimary, width: 5)),
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(firebaseAuth.currentUser != null
                          ? "${firebaseAuth.currentUser.photoURL}"
                          : "https://www.w3schools.com/howto/img_avatar.png", fit: BoxFit.cover,),
                    ),
                  ),
                ),
                new SizedBox(
                  height: size.height * 0.01,
                ),
                new Container(
                  alignment: Alignment.center,
                  child: new Text(
                    firebaseAuth.currentUser != null
                        ? "${firebaseAuth.currentUser.displayName}"
                        : "",
                    style: TextStyle(color: colorScheme.onSecondary, fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                )
              ],
            )),
            new Container(
              width: size.width,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: new Text("© Vocal Cast", style: TextStyle(color: colorScheme.secondaryVariant, fontWeight: FontWeight.w600, fontSize: 16),),
                  ),
                  new Row(
                    children: [
                      Expanded(
                          child: Divider(color: colorScheme.secondaryVariant, thickness: 1,),
                        flex: 1,
                      ),

                      Text(" Version 1.0.0 ", style: TextStyle(fontSize: 14, color: colorScheme.secondaryVariant),),

                      Expanded(
                          child: Divider(color: colorScheme.secondaryVariant, thickness: 1,),
                        flex: 9,
                      ),
                    ],
                  ),
                  new SizedBox(height: size.height*0.02,)
                ],
              )
            )
          ],
        ),);
  }

  Future<void> displayDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Support"),
            actionScrollController: ScrollController(
                keepScrollOffset: true, initialScrollOffset: 20.0),
            scrollController: ScrollController(
                keepScrollOffset: true, initialScrollOffset: 20.0),
            actions: [
              CupertinoDialogAction(
                child: Column(
                  children: [
                    Icon(
                      Icons.call,
                      size: 30.0,
                    ),
                    Text("Call", style: TextStyle(color: Colors.grey))
                  ],
                ),
                onPressed: () => launch("tel:${7007953935}"),
              ),
              CupertinoDialogAction(
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 30.0,
                    ),
                    Text(
                      "Chat Support",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}
