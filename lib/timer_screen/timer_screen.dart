import 'package:basketball_workouts/model/work_interval.dart';
import 'package:basketball_workouts/timer_screen/timer_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  final intervals;

  TimerScreen(this.intervals);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String intervalLengthText;
  TimerScreenViewModel viewModel;
  ItemScrollController _scrollController = ItemScrollController();
  int workoutProgress;
  String workoutTimer;

  @override
  void initState() {
    super.initState();
    viewModel = TimerScreenViewModel(widget.intervals, _scrollToInterval, _pop);
    workoutProgress = viewModel.getWorkoutLengthInSeconds();
    workoutTimer = _secondsToString(workoutProgress);
  }

//  void callBack(int timerCount) {
//    setState(() {
//      workoutTimer = _secondsToString(timerCount);
//    });
//  }

  void _scrollToInterval(int index) {
    _scrollController.scrollTo(index: index, duration: Duration(seconds: 1));
  }

  void _startPressed() async {
    setState(() {
      viewModel.start();
    });
  }

  void _stopPressed() {
    setState(() {
      viewModel.stop();
    });
  }

  void _resetPressed() {
    setState(() {
      viewModel.reset();
    });
  }

  Future<bool> _onBackPressed() {
    _stopPressed();
    _pop();
  }

  void _pop() {
    Navigator.of(context).pop();
  }

  Widget buildIntervalWidget(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Consumer<TimerScreenViewModel>(builder: (context, viewModel, child) {
          WorkInterval interval = viewModel.intervals[index];

          var color;
          var icon;
          var progressIndicator;

          if (viewModel.intervalIndex == index) {
            progressIndicator = LinearProgressIndicator(
              value: viewModel.getProgressPercentage(),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            );
            if (viewModel.mode == TimerMode.duration) {
              color = Colors.red;
              icon = Icons.directions_run;
            } else if (viewModel.mode == TimerMode.rest) {
              color = Colors.green;
              icon = Icons.timer;
            }
          }

          return Card(
              elevation: 5,
              color: color,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(icon),
                          Expanded(
                            child: Text(
                              interval.description,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          progressIndicator != null
                              ? Text(
                                  _secondsToString(
                                      viewModel.intervalDuration.inSeconds),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  progressIndicator != null ? progressIndicator : Container(),
                ],
              ));
        }),
      ],
    );
  }

  String _secondsToString(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    var minString = min.toString();
    var secString = sec.toString();

    if (min < 10) {
      minString = "0${min.toString()}";
    }

    if (sec < 10) {
      secString = "0${sec.toString()}";
    }

    return minString + ":" + secString;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Workout Player"),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Consumer<TimerScreenViewModel>(
                            builder: (context, viewModel, child) {
                              return Text(
                                _secondsToString(viewModel.workoutRemaining),
                                style: TextStyle(
                                    fontSize: 100.0,
                                    fontWeight: FontWeight.w700),
                              );
                            },
                          )
//                          Container(
//                            child: Text(
//                              workoutTimer,
//                              style: TextStyle(
//                                  fontSize: 100.0, fontWeight: FontWeight.w700),
//                            ),
//                          ),
                        ],
                      ),
                    )),
                Container(
                  height: 200,
                  width: 250,
                  child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: viewModel.intervals.length,
                      itemBuilder: (context, index) {
                        return buildIntervalWidget(index);
                      }),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Consumer<TimerScreenViewModel>(
                              builder: (context, viewModel, child) {
                                return RaisedButton(
                                    onPressed: !viewModel.isRunning
                                        ? _startPressed
                                        : null,
                                    color: Colors.green,
                                    child: Text("Start"));
                              },
                            ),
                            Consumer<TimerScreenViewModel>(
                              builder: (context, viewModel, child) {
                                return RaisedButton(
                                  onPressed: viewModel.isRunning
                                      ? _stopPressed
                                      : _resetPressed,
                                  color: Colors.red,
                                  child: Text(
                                      viewModel.isRunning ? "Stop" : "Reset"),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
