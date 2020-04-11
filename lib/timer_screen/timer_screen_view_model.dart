import 'dart:async';
import 'package:basketball_workouts/util/text_to_speech.dart';
import 'package:flutter/cupertino.dart';

import 'package:basketball_workouts/model/work_interval.dart';

enum TimerMode {
  duration,
  rest,
}

class TimerScreenViewModel extends ChangeNotifier {
  final second = Duration(seconds: 1);
  final List<WorkInterval> intervals;
  void Function(int) _callBack;
  void Function(int) _scrollCallBack;
  void Function() _popCallBack;
  Stopwatch stopwatch;
  var intervalIndex = 0;
  var _intervalDuration = 0;

  int get intervalDuration => (mode == TimerMode.duration
      ? intervals[intervalIndex].duration
      : intervals[intervalIndex].rest) - _intervalDuration;
  TimerMode mode;
  TextToSpeech tts;
  int workoutLengthInSeconds;
  bool stopPressed = false;

  TimerScreenViewModel(
      this.intervals, this._callBack, this._scrollCallBack, this._popCallBack) {
    workoutLengthInSeconds = getWorkoutLengthInSeconds();
    _swatch = Stopwatch();
    _initTts();
  }

  void _initTts() async {
    tts = await TextToSpeech.newInstance();
  }

  Stopwatch _swatch;
  Timer _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;
  int get workoutRemaining => workoutLengthInSeconds - _currentDuration.inSeconds;

  bool get isRunning => _timer != null;

  void _onTick(Timer timer) {
    _currentDuration = _swatch.elapsed;

    _intervalDuration++;

    if (mode == TimerMode.duration &&
        _intervalDuration == intervals[intervalIndex].duration) {
      mode = TimerMode.rest;
      _intervalDuration = 0;
      tts.speak("REST");
    } else if (mode == TimerMode.rest &&
        _intervalDuration == (intervals[intervalIndex].rest)) {
      mode = TimerMode.duration;
      _intervalDuration = 0;
      intervalIndex++;
      _scrollCallBack(intervalIndex);

      if (intervalIndex >= intervals.length) {
        //check if workout is completed
        tts.speak("Workout completed");
        _popCallBack();
      } else {
        tts.speak(intervals[intervalIndex].description);
      }
    }

    if(stopPressed){

    }

    notifyListeners();
  }

  void start() {
    if (_timer != null) return;
    if (mode == null) {
      mode = TimerMode.duration;
    }

    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _swatch.start();

    if(mode == TimerMode.duration){
      tts.speak(intervals[intervalIndex].description);
    } else {
      tts.speak("Rest");
    }


    notifyListeners();
  }

  void stop() {
    stopPressed = true;
    _timer?.cancel();
    _timer = null;
    _swatch.stop();
    _currentDuration = _swatch.elapsed;

    notifyListeners();
  }

  void reset() {
    stop();
    _swatch.reset();
    _currentDuration = Duration.zero;
    _intervalDuration = 0;
    intervalIndex = 0;

    notifyListeners();
  }

  String getExercise() {
    return intervals[intervalIndex].description;
  }

  double getProgressPercentage() {
    double res = 1;

    if (mode == TimerMode.duration) {
      res = intervalDuration / intervals[intervalIndex].duration;
    } else if (mode == TimerMode.rest) {
      res = intervalDuration / intervals[intervalIndex].rest;
    }

    return res;
  }

  int getWorkoutLengthInSeconds() {
    int res = 0;

    for (var interval in intervals) {
      res += interval.duration + interval.rest;
    }

    return res;
  }
}
