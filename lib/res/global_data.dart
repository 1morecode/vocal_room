
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class GlobalData {
  static final GlobalObjectKey<ScaffoldState> scaffoldKey =
      GlobalObjectKey(ScaffoldState);

  static String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  // static String googleApiKey = "AIzaSyBQ-AWcWaBtDbDMVoPjEBfLSNr6kHL3oG4";
  static String googleApiKey = "AIzaSyC5m-C32piW2yiT3kevVbvLfHXsLsPTWik";
  static String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static void showSnackBar(String message, BuildContext context, Color color) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showSimpleNotification(
      Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.primary, width: 1,),
            borderRadius: BorderRadius.circular(100)
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Icon(Icons.info_outline, color: colorScheme.onSecondary, size: 24,),
              new SizedBox(width: 15,),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text("$message", style: TextStyle(color: colorScheme.onSecondary, fontSize: 16, fontWeight: FontWeight.w400),),
                ],
              )
            ],
          ),
        ),
      ),
      position: NotificationPosition.bottom,
      slideDismissDirection: DismissDirection.horizontal,
      duration: Duration(milliseconds: 2000),
      background: Colors.transparent,
    );
  }

  static int currentEpisodeTapped = 0;

}
