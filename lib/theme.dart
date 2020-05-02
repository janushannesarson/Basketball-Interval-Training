import 'package:basketball_workouts/settings_screen/settings_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  static ThemeChanger _instance;
  ThemeData _themeData;

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
      brightness: Brightness.dark,
      sliderTheme: SliderThemeData(
        thumbColor: Colors.tealAccent,
        activeTrackColor: Colors.tealAccent,
        valueIndicatorColor: Colors.tealAccent,
        inactiveTrackColor: Colors.teal[50],
        disabledActiveTickMarkColor: Colors.teal[100],
        activeTickMarkColor: Colors.teal[100],
        valueIndicatorTextStyle: TextStyle(
          color: Colors.black,
        ),
      ));

  ThemeChanger._(this._themeData);

  getTheme() => _themeData;

  setDarkTheme(bool value) {
    if (value) {
      _themeData = _darkTheme;
    } else {
      _themeData = _lightTheme;
    }
    notifyListeners();
  }

  isDarkMode() => _themeData.brightness == Brightness.dark;

  static Future<ThemeChanger> getInstance() async {
    if (_instance == null) {
      SettingsScreenViewModel settings =
          await SettingsScreenViewModel.newInstance();

      ThemeData initialTheme;

      if (settings.darkModeEnabled) {
        initialTheme = _darkTheme;
      } else {
        initialTheme = _lightTheme;
      }

      _instance = ThemeChanger._(initialTheme);
    }

    return _instance;
  }
}
