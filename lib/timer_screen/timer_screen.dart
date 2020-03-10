import 'package:basketball_workouts/model/work_interval.dart';
import 'package:basketball_workouts/timer_screen/timer_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class TimerScreen extends StatefulWidget {
  final intervals;

  TimerScreen(this.intervals);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String timerText;
  String intervalLengthText;
  TimerScreenViewModel viewModel;
  ItemScrollController _scrollController = ItemScrollController();
  double timerProgress = 1;
  double workoutProgress = 0.5;
  int test = 100;

  @override
  void initState() {
    super.initState();
    viewModel =
        TimerScreenViewModel(widget.intervals, callBack, _scrollToInterval);
    timerText = _secondsToString(viewModel.intervals[0].duration);
  }

  void callBack(int timerCount) {
    setState(() {
      this.timerText = _secondsToString(timerCount);
      timerProgress = viewModel.getProgressPercentage(timerCount);
    });
  }

  void _scrollToInterval(int index) {
    _scrollController.scrollTo(index: index, duration: Duration(seconds: 1));
  }

  void _startPressed() async{
    viewModel.startTimer();
  }

  void _stopPressed() {
    timerProgress = 1;
    viewModel.resetTimer();
  }

  Widget buildIntervalWidget(int index) {
    WorkInterval interval = viewModel.intervals[index];

    var color;
    var icon;
    var progressIndicator;

    if (viewModel.progress == index) {
      progressIndicator = LinearProgressIndicator(value: timerProgress, backgroundColor: Colors.red,);
      if (viewModel.mode == TimerMode.duration) {
        color = Colors.red;
        icon = Icons.directions_run;
      } else if (viewModel.mode == TimerMode.rest) {
        color = Colors.green;
        icon = Icons.timer;
      }
    } else {
      progressIndicator = Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
            elevation: 5,
            color: color,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Icon(icon),
                        Text(
                          interval.description,
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                progressIndicator,
              ],
            )),
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
    return Scaffold(
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
                      Container(
                        child: Text(
                          timerText,
                          style: TextStyle(
                              fontSize: 100.0, fontWeight: FontWeight.w700),
                        ),
                      ),
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
                        RaisedButton(
                          onPressed: viewModel.mode != TimerMode.stopped
                              ? null
                              : _startPressed,
                          color: Colors.green,
                          child: Text("Start"),
                        ),
                        RaisedButton(
                          onPressed: viewModel.mode == TimerMode.stopped
                              ? null
                              : _stopPressed,
                          color: Colors.red,
                          child: Text("Stop"),
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
    );
  }
}
