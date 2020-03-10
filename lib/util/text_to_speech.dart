import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextToSpeech{

  FlutterTts _tts = FlutterTts();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextToSpeech._privateConstructor(){
    _getLanguage();
  }

  void _getLanguage() async{
    SharedPreferences prefs = await _prefs;
    String language = prefs.getString("language");
    _tts.setLanguage(language ?? "en-US");
  }

  static final TextToSpeech instance = TextToSpeech._privateConstructor();

  Future speak(String speak) async{
    _tts.speak(speak);
  }

}