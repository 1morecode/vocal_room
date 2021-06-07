import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vocal/auth/login_provider.dart';
import 'package:vocal/res/widgets/ios_style_toast.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  var firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new CupertinoNavigationBar(
trailing: new CupertinoButton(child: new Icon(CupertinoIcons.arrowshape_turn_up_right_fill), onPressed: (){}),
      ),
      body: ListView(
        children: [
          new Container(
            width: size.width,
            height: size.width*0.8,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    colorScheme.onPrimary,
                    colorScheme.onSurface,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            padding: EdgeInsets.only(top: size.width*0.1),
            child: new Column(
              children: [
                new Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: colorScheme.onSurface,
                              offset: const Offset(2.0, 4.0),
                              blurRadius: 8),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(70.0)),
                          child: Image.network("${firebaseAuth.currentUser.photoURL}", fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    Container(
                      height: 120,
                      width: 110,
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                          child: LoginProviderIcon(15),
                        ),
                        radius: 10,
                        backgroundColor: colorScheme.surface,
                      ),
                    ),
                  ],
                ),
                new SizedBox(height: 10,),
                new Text("${firebaseAuth.currentUser.displayName}", style: TextStyle(
                  color: colorScheme.onSecondary, fontWeight: FontWeight.bold, fontSize: 24
                ),),
                new SizedBox(height: 5,),
                new Text("${firebaseAuth.currentUser.email}", style: TextStyle(
                    color: colorScheme.secondaryVariant, fontWeight: FontWeight.w600, fontSize: 18
                ),),
                new SizedBox(height: 5,),
                new Container(
                  child: new Row(
                    children: [
                      new Text("@${firebaseAuth.currentUser.uid}", style: TextStyle(
                          color: colorScheme.onSecondary, fontWeight: FontWeight.w400, fontSize: 14
                      ),),
                      Spacer(),
                      new CupertinoButton(child: new Icon(Icons.copy, color: colorScheme.primary,), onPressed: (){
                        showOverlay((_, t) {
                          return Theme(
                            data: Theme.of(context),
                            child: Opacity(
                              opacity: t,
                              child: IosStyleToast("Copied"),
                            ),
                          );
                        }, key: ValueKey('hello'));
                        Clipboard.setData(ClipboardData(text: "${firebaseAuth.currentUser.uid}"));
                      }, padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0,), minSize: 30,)
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: colorScheme.onSurface
                  ),
                  height: 40,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
