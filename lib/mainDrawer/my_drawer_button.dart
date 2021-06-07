import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class MyDrawerButton extends StatefulWidget {

  final Color btnColor;

  MyDrawerButton(this.btnColor);

  @override
  _MyDrawerButtonState createState() => _MyDrawerButtonState();
}

class _MyDrawerButtonState extends State<MyDrawerButton> {
  SimpleHiddenDrawerController controller;

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return IconButton(
      color: colorScheme.primary,
      icon: Icon(
        CupertinoIcons.equal_circle,
        size: 28,
        color: widget.btnColor,
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        controller.toggle();
        // GlobalData.scaffoldKey.currentState.openDrawer();
      },
    );
  }
}
