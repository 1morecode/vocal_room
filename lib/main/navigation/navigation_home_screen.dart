import 'package:flutter/material.dart';
import 'package:vocal/main/inside_drawer/about.dart';
import 'package:vocal/main/inside_drawer/notification/page/notification_page.dart';
import 'package:vocal/main/inside_drawer/privacy_policy.dart';
import 'package:vocal/main/inside_drawer/terms_of_use.dart';
import 'package:vocal/main/main_page.dart';
import 'package:vocal/main/navigation/custom_drawer/drawer_user_controller.dart';
import 'package:vocal/main/navigation/custom_drawer/home_drawer.dart';
class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = MainPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.onSurface,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: colorScheme.onSurface,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    print("DDDD $drawerIndex $drawerIndexdata");
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = MainPage();
        });
      } else if (drawerIndex == DrawerIndex.AboutUs) {
        setState(() {
          screenView = AboutUs();
        });
      } else if (drawerIndex == DrawerIndex.Account) {
        setState(() {
          screenView = MainPage();
        });
      } else if (drawerIndex == DrawerIndex.Notification) {
        setState(() {
          screenView = NotificationPage();
        });
      } else if (drawerIndex == DrawerIndex.Settings) {
        setState(() {
          screenView = MainPage();
        });
      } else if (drawerIndex == DrawerIndex.Favorite) {
        setState(() {
          screenView = MainPage();
        });
      } else if (drawerIndex == DrawerIndex.ShareApp) {
        setState(() {
          screenView = MainPage();
        });
      } else if (drawerIndex == DrawerIndex.Support) {
        setState(() {
          screenView = MainPage();
        });
      } else if (drawerIndex == DrawerIndex.Terms) {
        setState(() {
          screenView = TermsOfUse();
        });
      } else if (drawerIndex == DrawerIndex.Privacy) {
        setState(() {
          screenView = PrivacyPolicy();
        });
      } else {
        //do in your way......
      }
    }
  }
}
