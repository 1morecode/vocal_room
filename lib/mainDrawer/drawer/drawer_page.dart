import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/auth/login_provider.dart';
import 'package:vocal/mainPage/insideDrawer/about.dart';
import 'package:vocal/mainPage/insideDrawer/notification/page/notification_page.dart';
import 'package:vocal/mainPage/insideDrawer/privacy_policy.dart';
import 'package:vocal/mainPage/insideDrawer/support_page.dart';
import 'package:vocal/mainPage/insideDrawer/terms_of_use.dart';
import 'package:vocal/mainPage/profile/my_profile_page.dart';
import 'package:vocal/mainPage/settings/setting_page.dart';
import 'package:vocal/theme/app_state.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  List<DrawerList> drawerList;
  SimpleHiddenDrawerController controller;
  var firebaseAuth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Dashboard',
        icon: CupertinoIcons.square_grid_2x2_fill,
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
        index: DrawerIndex.Setting,
        labelName: 'Settings',
        icon: CupertinoIcons.settings_solid,
      ),
      DrawerList(
        index: DrawerIndex.RateUs,
        labelName: 'Rate Us',
        icon: CupertinoIcons.star_circle,
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

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    var themeState = Provider.of<ThemeState>(context, listen: true);
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: new Row(
        children: [
          new Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  new Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
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
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(60.0)),
                                            child: Image.network(
                                              firebaseAuth.currentUser != null
                                                  ? "${firebaseAuth.currentUser.photoURL}"
                                                  : "https://www.w3schools.com/howto/img_avatar.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 110,
                                        width: 100,
                                        alignment: Alignment.bottomCenter,
                                        child: CircleAvatar(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(60.0)),
                                            child: LoginProviderIcon(15),
                                          ),
                                          radius: 10,
                                          backgroundColor: colorScheme.surface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // FlutterSwitch(
                                  //   width: 45.0,
                                  //   height: 45.0,
                                  //   toggleSize: 30.0,
                                  //   value: themeState.darkMode,
                                  //   borderRadius: 30.0,
                                  //   padding: 2.0,
                                  //   activeToggleColor: Color(0xFF6E40C9),
                                  //   inactiveToggleColor: Color(0xFF2F363D),
                                  //   activeSwitchBorder: Border.all(
                                  //     color: Color(0xFF3C1E70),
                                  //     width: 6.0,
                                  //   ),
                                  //   inactiveSwitchBorder: Border.all(
                                  //     color: Color(0xFFD1D5DA),
                                  //     width: 6.0,
                                  //   ),
                                  //   activeColor: Color(0xFF271052),
                                  //   inactiveColor: Colors.white,
                                  //   activeIcon: Icon(
                                  //     Icons.nightlight_round,
                                  //     color: Color(0xFFF8E3A1),
                                  //   ),
                                  //   inactiveIcon: Icon(
                                  //     Icons.wb_sunny,
                                  //     color: Color(0xFFFFDF5D),
                                  //   ),
                                  //   onToggle: (val) async {
                                  //     themeState.toggleChangeTheme();
                                  //   },
                                  // )
                                ],
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
                                  style: TextStyle(
                                      color: colorScheme.onSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
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
                            child: Divider(
                              color: colorScheme.onSurface,
                              thickness: 1,
                            ),
                            flex: 5,
                          ),
                          Text(
                            " Version 1.0.0 ",
                            style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.secondaryVariant),
                          ),
                          Expanded(
                            child: Divider(
                              color: colorScheme.onSurface,
                              thickness: 1,
                            ),
                            flex: 5,
                          ),
                        ],
                      ),
                      new SizedBox(
                        height: size.height * 0.01,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0.0),
                        itemCount: drawerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return inkwell(drawerList[index]);
                        },
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.onSurface,
                ),
              ],
            ),
            width: size.width * 0.7,
          ),
          Expanded(child: new Container())
        ],
      ),
    );
  }

  updateShared(val) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("themeMode", val);
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: CupertinoButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (listData.index == DrawerIndex.HOME) {
            controller.toggle();
          } else if (listData.index == DrawerIndex.AboutUs) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUs(),
                ));
          } else if (listData.index == DrawerIndex.Account) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProfilePage(),
                ));
          } else if (listData.index == DrawerIndex.Notification) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ));
          } else if (listData.index == DrawerIndex.Setting) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPage(),
                ));
          } else if (listData.index == DrawerIndex.RateUs) {
            controller.toggle();
            rateApp();
            // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentsPage(),));
          } else if (listData.index == DrawerIndex.ShareApp) {
            controller.toggle();
            // Share.shareFiles(['assets/google.png'],
            //     text: 'Vocal Cast App',
            //     subject:
            //         "Vocal Cast App\nhttps://play.google.com/store/apps/details?id=co.mitwa\nDownload our application");
            Share.share("Vocal Cast App\nhttps://play.google.com/store/apps/details?id=co.mitwa\nDownload our application");
          } else if (listData.index == DrawerIndex.Support) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportPage(),
                ));
          } else if (listData.index == DrawerIndex.Terms) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsOfUse(),
                ));
          } else if (listData.index == DrawerIndex.Privacy) {
            controller.toggle();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(),
                ));
          } else {
            controller.toggle();
          }
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
                  Icon(
                    listData.icon,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondaryVariant),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              child: listData.index == DrawerIndex.HOME
                  ? Container(
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
                    )
                  : new Container(),
            )
          ],
        ),
      ),
    );
  }

  rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

// Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
//   widget.callBackIndex(indexScreen);
// }
}

enum DrawerIndex {
  HOME,
  AboutUs,
  Account,
  Notification,
  Setting,
  RateUs,
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
