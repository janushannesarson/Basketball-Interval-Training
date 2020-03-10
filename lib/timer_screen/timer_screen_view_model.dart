import 'dart:async';
import 'package:basketball_workouts/util/text_to_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  //var cancelPressed = false;
  //var startPressed = false;
  TimerMode mode = TimerMode.stopped;

  TimerScreenViewModel(this.intervals, this._callBack, this._scrollCallBack);

  void startTimer() {
    TextToSpeech.instance.speak(intervals[progress].description);
    mode = TimerMode.duration;
    //startPressed = true;
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
    if(mode != TimerMode.stopped){
      _startRest();
    }
  }

  void _startRest(){
    TextToSpeech.instance.speak("rest");
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
    if(mode != TimerMode.stopped){
      progress += 1;
      if(progress < intervals.length){
        _scrollCallBack(progress);
        startTimer();
      } else {
        resetTimer();
      }
    }

  }

  void resetTimer() {
    mode = TimerMode.stopped;
    progress = 0;
    countdownTimer.cancel();
    _callBack(0);
  }

  String getExercise(){
    return intervals[progress].description;
  }

  double getProgressPercentage(int seconds){
    double res = 1;

    if(mode == TimerMode.duration){
      res = seconds / intervals[progress].duration;
    }else if(mode == TimerMode.rest){
      res = seconds / intervals[progress].rest;
    }

    return res;
  }

  int getWorkoutLengthInSeconds(){
    int res = 0;

    for(var interval in intervals){
      res += interval.duration + interval.rest;
    }

    return res;
  }

}
