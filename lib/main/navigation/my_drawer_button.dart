import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/res/global_data.dart';

class MyDrawerButton extends StatefulWidget {
  @override
  _MyDrawerButtonState createState() => _MyDrawerButtonState();
}

class _MyDrawerButtonState extends State<MyDrawerButton> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return IconButton(
      color: colorScheme.primary,
      icon: Icon(
        CupertinoIcons.equal_circle,
        size: 28,
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        GlobalData.onDrawerClick();
        // GlobalData.scaffoldKey.currentState.openDrawer();
      },
    );
  }
}
