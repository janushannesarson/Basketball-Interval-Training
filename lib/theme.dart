import 'package:basketball_workouts/settings_screen/settings_screen_view_model.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  static ThemeChanger _instance;
  ThemeData _themeData;

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.red,
    accentColor: Colors.red,
    buttonColor: Colors.red,
    sliderTheme: SliderThemeData(
      thumbColor: Colors.red,
      activeTrackColor: Colors.red,
      valueIndicatorColor: Colors.red,
      inactiveTrackColor: Colors.red[200],
      disabledActiveTickMarkColor: Colors.red[600],
      activeTickMarkColor: Colors.red[600],
      valueIndicatorTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  ThemeChanger(){
    _themeData = _lightTheme;
  }

  getTheme() => _themeData;

  static Future<ThemeChanger> getInstance() async {
    if (_instance == null) {
      _instance = ThemeChanger();
    }

    return _instance;
  }
}
