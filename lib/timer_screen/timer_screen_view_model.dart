import 'dart:async';
import 'package:quiver/async.dart';

import 'package:basketball_workouts/model/work_interval.dart';

enum TimerMode {
  duration,
  rest,
  stopped,
  paused
}

class TimerScreenViewModel {
  final List<WorkInterval> intervals;
  var timer = "00:00";
  void Function(int) _callBack;
  void Function(int) _scrollCallBack;
  CountdownTimer countdownTimer;
  var progress = 0;
  var cancelPressed = false;
  var startPressed = false;
  TimerMode mode = TimerMode.stopped;

  TimerScreenViewModel(this.intervals, this._callBack, this._scrollCallBack);

  void startTimer() {
    mode = TimerMode.duration;
    startPressed = true;
    final interval = intervals[progress];

    countdownTimer = new CountdownTimer(
        Duration(seconds: interval.duration), Duration(seconds: 0));

    countdownTimer.listen((onData) {
      _callBack(onData.remaining.inSeconds);
    }, onDone: () => {
      _durationDone()
    });
  }

  void _durationDone() {
    if (!cancelPressed) {
      _startRest();
    }
    cancelPressed = false;
  }

  void _startRest(){
    mode = TimerMode.rest;
    countdownTimer = new CountdownTimer(
        Duration(seconds: intervals[progress].rest), Duration(seconds: 0));

    countdownTimer.listen((onData) {
      _callBack(onData.remaining.inSeconds);
    }, onDone: () => {
      _restDone()
    });
  }

  void _restDone() {
    if (!cancelPressed) {
      progress += 1;
      if (progress < intervals.length) {
        _scrollCallBack(progress);
        startTimer();
      } else {
        resetTimer();
      }
    }
    cancelPressed = false;
  }

  void resetTimer() {
    mode = TimerMode.stopped;
    startPressed = false;
    cancelPressed = true;
    progress = 0;
    countdownTimer.cancel();
    _callBack(0);
  }

  String getExercise(){
    return intervals[progress].description;
  }

}
