import 'package:flutter/material.dart';

class GlobalData{

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
}