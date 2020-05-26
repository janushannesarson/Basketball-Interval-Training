import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const YOUR_WORKOUTS = "Your Workouts";
  static const CLICK_TO_CREATE_WORKOUT = "Click to create workout";
  static const WORKOUTS = "Workouts";
  static const SETTINGS = "Settings";
  static const TEXT_TO_SPEECH_ENABLED = "Text to speech enabled";
  static const TEXT_TO_SPEECH_VOLUME = "Text to speech volume";
  static const TEXT_TO_SPEECH_RATE = "Text to speech rate";
  static const NEW_WORKOUT = "New Workout";
  static const WORKOUT_NAME = "Workout name";
  static const CREATE_WORKOUT = "Create workout";
  static const TOTAL_TIME = "Total time";
  static const CLICK_TO_ADD_INTERVAL = "Click to add interval";
  static const NEW_INTERVAL = "New Interval";
  static const EXERCISE = "Exercise";
  static const SUGGESTIONS = "Suggestions";
  static const ADD_INTERVAL = "Add interval";


  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      YOUR_WORKOUTS: YOUR_WORKOUTS,
      CLICK_TO_CREATE_WORKOUT: CLICK_TO_CREATE_WORKOUT,
      WORKOUTS: WORKOUTS,
      SETTINGS: SETTINGS,
      TEXT_TO_SPEECH_ENABLED: TEXT_TO_SPEECH_ENABLED,
      TEXT_TO_SPEECH_VOLUME: TEXT_TO_SPEECH_VOLUME,
      TEXT_TO_SPEECH_RATE: TEXT_TO_SPEECH_RATE,
      NEW_WORKOUT: NEW_WORKOUT,
      WORKOUT_NAME: WORKOUT_NAME,
      CREATE_WORKOUT: CREATE_WORKOUT,
      TOTAL_TIME: TOTAL_TIME,
      CLICK_TO_ADD_INTERVAL: CLICK_TO_ADD_INTERVAL,
      NEW_INTERVAL: NEW_INTERVAL,
      EXERCISE: EXERCISE,
      SUGGESTIONS: SUGGESTIONS,
      ADD_INTERVAL: ADD_INTERVAL,
    },
    'es': {
      YOUR_WORKOUTS: 'Tus entrenamientos',
      CLICK_TO_CREATE_WORKOUT: 'Haga clic para crear entrenamiento',
      WORKOUTS: 'Entrenamientos',
      SETTINGS: 'Configuraciones',
      TEXT_TO_SPEECH_ENABLED: 'Habilitar texto a voz',
      TEXT_TO_SPEECH_VOLUME: 'Volumen de texto a voz',
      TEXT_TO_SPEECH_RATE: 'Velocidad de texto a voz',
      NEW_WORKOUT: 'Nuevo entrenamiento',
      WORKOUT_NAME: 'Nombre del entrenamiento',
      CREATE_WORKOUT: 'Crear entrenamiento',
      TOTAL_TIME: 'Tiempo Total',
      CLICK_TO_ADD_INTERVAL: 'Haga clic para agregar intervalo',
      NEW_INTERVAL: 'Nueva intervalo',
      EXERCISE: "Ejercicio",
      SUGGESTIONS: "Catalogar",
      ADD_INTERVAL: "Agregar intervalo",
    },
  };

  String getString(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
