import 'dart:async';
import 'package:basketball_workouts/util/text_to_speech.dart';
import 'package:flutter/cupertino.dart';

import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';

enum TimerMode {
  duration,
  rest,
}

class TimerScreenViewModel extends ChangeNotifier {
  final List<WorkInterval> intervals;
  void Function(int) _scrollCallBack;
  void Function() _popCallBack;
  var intervalIndex = 0;

  TimerMode mode;
  TextToSpeech tts;
  int workoutLengthInSeconds;
  bool stopPressed = false;
  Stopwatch _workoutStopWatch;
  Timer _timer;

  Duration get workoutDuration => _workoutStopWatch.elapsed;

  Duration get intervalDuration => _intervalDuration;
  Duration _intervalDuration = Duration.zero;

  int get workoutRemaining =>
      workoutLengthInSeconds - _workoutStopWatch.elapsed.inSeconds;

  bool get isRunning => _timer != null;

  List durationCheckPoints;
  List restCheckPoints;

  TimerScreenViewModel(
      this.intervals, this._scrollCallBack, this._popCallBack) {
    workoutLengthInSeconds = getWorkoutLengthInSeconds();
    _workoutStopWatch = Stopwatch();
    mode = TimerMode.duration;
    _initTts();
    _initCheckPoints();
    _intervalDuration = Duration(seconds: durationCheckPoints[0]);
  }

  void _initTts() async {
    tts = await TextToSpeech.newInstance();
  }

  void _initCheckPoints() {
    durationCheckPoints = List(intervals.length);
    restCheckPoints = List(intervals.length);

    int runningSum = 0;

    for (int i = 0; i < intervals.length; i++) {
      runningSum += intervals[i].duration;
      durationCheckPoints[i] = runningSum;

      runningSum += intervals[i].rest;
      restCheckPoints[i] = runningSum;
    }
  }

  void _setIntervalDuration() {
    int toSub;

    if (mode == TimerMode.duration) {
      toSub = durationCheckPoints[intervalIndex];
    } else {
      toSub = restCheckPoints[intervalIndex];
    }

    int intervalProgressInSeconds = toSub - _workoutStopWatch.elapsed.inSeconds;

    _intervalDuration = Duration(seconds: intervalProgressInSeconds);
    notifyListeners();
  }

  void _onTick(Timer timer) {
    if (mode == TimerMode.duration &&
        durationCheckPoints[intervalIndex] ==
            _workoutStopWatch.elapsed.inSeconds) {
      mode = TimerMode.rest;
      _intervalDuration = Duration.zero;
      tts.speak("REST");
    } else if (mode == TimerMode.rest &&
        restCheckPoints[intervalIndex] == _workoutStopWatch.elapsed.inSeconds) {
      mode = TimerMode.duration;
      _intervalDuration = Duration.zero;
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

    _setIntervalDuration();
    notifyListeners();
  }

  void start() {
    if (_timer != null) return;
    if (mode == null) {
      mode = TimerMode.duration;
    }

    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _workoutStopWatch.start();

    if (mode == TimerMode.duration) {
      tts.speak(intervals[intervalIndex].description);
    } else {
      tts.speak("Rest");
    }
    _setIntervalDuration();
    notifyListeners();
  }

  void stop() {
    stopPressed = true;
    _timer?.cancel();
    _timer = null;
    _workoutStopWatch.stop();
    _setIntervalDuration();
  }

  void reset() {
    stop();
    mode = TimerMode.duration;
    _workoutStopWatch.reset();
    _intervalDuration = Duration(seconds: durationCheckPoints[0]);
    intervalIndex = 0;
    _scrollCallBack(intervalIndex);

    notifyListeners();
  }

  String getExercise() {
    return intervals[intervalIndex].description;
  }

  double getProgressPercentage() {
    double res = 1;

    if (mode == TimerMode.duration) {
      res = intervalDuration.inSeconds / intervals[intervalIndex].duration;
    } else if (mode == TimerMode.rest) {
      res = intervalDuration.inSeconds / intervals[intervalIndex].rest;
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
