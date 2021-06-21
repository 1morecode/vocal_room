import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  final String key = "themeMode";
  SharedPreferences _preferences;
  bool isDarkModeOn;

  bool get darkMode => isDarkModeOn;

  ThemeState() {
    isDarkModeOn = false;
    _loadFromPreferences();
  }

  _initialPreferences() async {
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences()async {
    await _initialPreferences();
    _preferences.setBool(key, isDarkModeOn);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    isDarkModeOn = _preferences.getBool(key) ?? false;
    notifyListeners();
  }

  toggleChangeTheme(){
    isDarkModeOn = !isDarkModeOn;
    _savePreferences();
    notifyListeners();
  }


}