import 'package:basketball_workouts/settings_screen/settings_screen_view_model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextToSpeech{

  FlutterTts _tts = FlutterTts();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextToSpeech(){
    _init();
  }

  void _init() async{
    SharedPreferences prefs = await _prefs;
    String language = prefs.getString("language");
    _tts.setLanguage(language ?? "en-US");

    double speechRate = prefs.getDouble(SPEECH_RATE);
    _tts.setSpeechRate(speechRate);

    double volume = prefs.getDouble(TTS_VOLUME);
    _tts.setVolume(volume);
  }

  Future speak(String speak) async{
    _tts.speak(speak);
  }

  static Future<TextToSpeech> newInstance() async{
    final prefs = await SharedPreferences.getInstance();
    bool ttsEnabled = prefs.getBool(TTS_ENABLED);

    TextToSpeech tts;

    if(ttsEnabled){
      tts = TextToSpeech();
    }

    return tts;
  }

}