import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

const SPEECH_RATE = "speech_rate";
const TTS_ENABLED = "tts_enabled";
const TTS_VOLUME = "tts_volume";

class SettingsScreenViewModel {
  double _ttsVolume;
  double get ttsVolume => _ttsVolume;
  set ttsVolume(double value) {
    _ttsVolume = value;
    save();
  }

  bool _ttsEnabled;
  bool get ttsEnabled => _ttsEnabled;
  set ttsEnabled(bool value) {
    _ttsEnabled = value;
    save();
  }

  double _speechRate;
  double get speechRate => _speechRate;
  set speechRate(double value) {
    _speechRate = value;
    save();
  }

  ThemeChanger _themeChanger;
  set themeChanger(ThemeChanger value){
    _themeChanger = value;
  }

  SettingsScreenViewModel._();

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(SPEECH_RATE, _speechRate);
    prefs.setBool(TTS_ENABLED, _ttsEnabled);
    prefs.setDouble(TTS_VOLUME, _ttsVolume);
  }

  Future _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _speechRate = prefs.getDouble(SPEECH_RATE) ?? 1;
    _ttsEnabled = prefs.getBool(TTS_ENABLED) ?? true;
    _ttsVolume = prefs.getDouble(TTS_VOLUME) ?? 1;
  }

  static Future<SettingsScreenViewModel> newInstance() async {
    var viewModel = SettingsScreenViewModel._();
    await viewModel._init();

    return viewModel;
  }
}
