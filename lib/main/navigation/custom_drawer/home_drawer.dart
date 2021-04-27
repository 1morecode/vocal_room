import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  var firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: CupertinoIcons.music_house,
      ),
      DrawerList(
        index: DrawerIndex.AboutUs,
        labelName: 'About Us',
        icon: CupertinoIcons.info_circle,
      ),
      DrawerList(
        index: DrawerIndex.Account,
        labelName: 'Account',
        icon: CupertinoIcons.person_alt_circle,
      ),
      DrawerList(
        index: DrawerIndex.Notification,
        labelName: 'Notification',
        icon: CupertinoIcons.bell_circle,
      ),
      DrawerList(
        index: DrawerIndex.Settings,
        labelName: 'Facilities',
        icon: CupertinoIcons.settings_solid,
      ),
      DrawerList(
        index: DrawerIndex.Favorite,
        labelName: 'Rate Us',
        icon: CupertinoIcons.heart_circle,
      ),
      DrawerList(
        index: DrawerIndex.ShareApp,
        labelName: 'Share App',
        icon: CupertinoIcons.arrowshape_turn_up_right_circle,
      ),
      DrawerList(
        index: DrawerIndex.Support,
        labelName: 'Support',
        icon: CupertinoIcons.phone_circle,
      ),
      DrawerList(
        index: DrawerIndex.Terms,
        labelName: 'Terms & Conditions',
        icon: CupertinoIcons.exclamationmark_shield,
      ),
      DrawerList(
        index: DrawerIndex.Privacy,
        labelName: 'Privacy Policy',
        icon: CupertinoIcons.lock_shield,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(height: 25,),
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(parent: widget.iconAnimationController, curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: colorScheme.onSurface, offset: const Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                              child: Image.network(firebaseAuth.currentUser != null
                                  ? "${firebaseAuth.currentUser.photoURL}"
                                  : "https://www.w3schools.com/howto/img_avatar.png", fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                      );
                    },
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
              ),
            ),
          ),
          new SizedBox(
            height: size.height * 0.01,
          ),
          new Row(
            children: [
              Expanded(
                child: Divider(color: colorScheme.onSurface, thickness: 1,),
                flex: 5,
              ),
              Text(" Version 1.0.0 ", style: TextStyle(fontSize: 12, color: colorScheme.secondaryVariant),),
              Expanded(
                child: Divider(color: colorScheme.onSurface, thickness: 1,),
                flex: 5,
              ),
            ],
          ),
          new SizedBox(
            height: size.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.onSurface,
          ),
          new Container(
              width: size.width,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: new Row(
                      children: [
                        Expanded(
                          child: Container(),
                          flex: 1,
                        ),

                        Text(" © Vocal Cast ", style: TextStyle(fontSize: 16, color: colorScheme.secondaryVariant),),

                        Expanded(
                          child: Container(),
                          flex: 9,
                        ),
                      ],
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: CupertinoButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: 46,
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Icon(listData.icon, color: widget.screenIndex == listData.index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryVariant,),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryVariant
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 2, bottom: 2),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  AboutUs,
  Account,
  Notification,
  Settings,
  Favorite,
  ShareApp,
  Support,
  Terms,
  Privacy,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  IconData icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
