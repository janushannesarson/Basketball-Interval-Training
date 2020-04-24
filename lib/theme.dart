import 'package:basketball_workouts/settings_screen/settings_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier{

  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setDarkTheme(bool value) {
    if(value){
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light();
    }
    notifyListeners();
  }

  static Future<ThemeChanger> newInstance() async {
    SettingsScreenViewModel settings = await SettingsScreenViewModel.newInstance();

    ThemeData initialTheme;

    if(settings.darkModeEnabled){
      initialTheme = ThemeData.dark();
    } else {
      initialTheme = ThemeData.light();
    }

    return ThemeChanger(initialTheme);
  }




}