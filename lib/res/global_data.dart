
import 'package:flutter/material.dart';

class GlobalData {
  static final GlobalObjectKey<ScaffoldState> scaffoldKey =
      GlobalObjectKey(ScaffoldState);

  static String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  // static String googleApiKey = "AIzaSyBQ-AWcWaBtDbDMVoPjEBfLSNr6kHL3oG4";
  static String googleApiKey = "AIzaSyC5m-C32piW2yiT3kevVbvLfHXsLsPTWik";
  static String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static void showSnackBar(String message, BuildContext context, Color color) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        '$message',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static ScrollController scrollController;

  static void onDrawerClick() {
    //if scrollcontroller.offset != 0.0 then we set to closed the drawer(with animation to offset zero position) if is not 1 then open the drawer
    if (GlobalData.scrollController.offset != 0.0) {
      GlobalData.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      GlobalData.scrollController.animateTo(
        250,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

}
