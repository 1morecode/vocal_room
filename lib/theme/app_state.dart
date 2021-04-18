import 'package:flutter/material.dart';

class ThemeState extends ChangeNotifier {
  bool isDarkModeOn = true;

  void updateTheme(bool isDarkModeOn) {
    this.isDarkModeOn = isDarkModeOn;
    notifyListeners();
  }
}
