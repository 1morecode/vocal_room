
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:vocal/mainDrawer/drawer/drawer_page.dart';
import 'package:vocal/mainPage/main_page.dart';

class MainAppPage extends StatefulWidget {
  @override
  _MainAppPageState createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
        verticalScalePercent: 100,
        slidePercent: 70,
        enableCornerAnimation: true,
        isDraggable: true,
        screenSelectedBuilder: (position, controller) => MainPage(),
        menu: DrawerPage());
  }
}
