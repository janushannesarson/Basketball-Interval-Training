import 'package:basketball_workouts/app_localizations.dart';
import 'package:basketball_workouts/home_screen/edit_interval_dialog.dart';
import 'package:basketball_workouts/home_screen/edit_workout_screen_view_model.dart';
import 'package:basketball_workouts/home_screen/new_interval_dialog.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:basketball_workouts/timer_screen/timer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditWorkoutScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;
  final BuildContext scaffoldContext;
  final void Function() fetchWorkoutsCallBack;

  EditWorkoutScreen({Key key,
    this.fetchWorkoutsCallBack,
    this.workoutId,
    this.workoutName,
    this.scaffoldContext})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  EditWorkoutScreenViewModel viewModel;
  Future<List> intervals;

  @override
  void initState() {
    viewModel = EditWorkoutScreenViewModel(workoutId: widget.workoutId);
    intervals = viewModel.getIntervals();
    super.initState();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      viewModel.onReorder(oldIndex, newIndex);
    });
  }

  void _addIntervalDialog() {
    showDialog(
        context: context,
        child: NewIntervalDialog(
          actualContext: context,
          onAddConfirmed: _onAddConfirmed,
        ));
  }

  void _onAddConfirmed(String exercise, int duration, int rest) {
    setState(() {
      viewModel.addInterval(exercise, duration, rest);
      intervals = viewModel.getIntervals();
    });
  }

  void _deleteInterval(WorkInterval interval) {
    setState(() {
      viewModel.deleteInterval(interval);
    });
  }

  void _onSaveConfirmed(int intervalId, String exercise, int duration,
      int rest) {
    setState(() {
      viewModel.updateInterval(intervalId, exercise, duration, rest);
      intervals = viewModel.getIntervals();
    });
  }

  void _editIntervalPressed(int intervalId, String exercise, int duration,
      int rest) {
    showDialog(
        context: context,
        child: EditIntervalDialog(
          actualContext: context,
          intervalId: intervalId,
          onSaveConfirmed: _onSaveConfirmed,
          exercise: exercise,
          duration: duration,
          rest: rest,
        ));
  }

  List<Widget> convertToCards(List<WorkInterval> intervals) {
    List<Widget> result = new List();

    for (int i = 0; i < intervals.length; i++) {
      final interval = intervals[i];

      result.add(Dismissible(
        background: Container(
          child: Center(child: Text("Delete interval")),
          color: Colors.red,
        ),
        key: Key(interval.id.toString()),
        onDismissed: (direction) {
          setState(() {
            _deleteInterval(interval);
          });
        },
        child: Container(
          child: Card(
            child: ListTile(
              title: Text("#${i + 1} " + interval.description),
              subtitle:
              Text("Duration: ${interval.duration} Rest: ${interval.rest}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    iconSize: 40,
                    tooltip: "Edit",
                    color: Colors.red,
                    icon: Icon(Icons.edit),
                    splashColor: Colors.amber,
                    onPressed: () {
                      _editIntervalPressed(interval.id, interval.description,
                          interval.duration, interval.rest);
                    },
                  ),
                  Icon(Icons.drag_handle),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return result;
  }

  Future<bool> _onBackPressed() async {
    await viewModel.saveWorkout();
    widget.fetchWorkoutsCallBack();
    return true;
  }

  void _startWorkoutPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
            new TimerScreen(viewModel.intervals)));
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final textColor = dark ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editing: ${widget.workoutName}"),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: FutureBuilder<List>(
          future: intervals,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              viewModel.intervals = snapshot.data;
              if (viewModel.intervals.isNotEmpty) {
                return ReorderableListView(
                  onReorder: _onReorder,
                  children: convertToCards(snapshot.data),
                );
              } else {
                return Center(
                    child: RaisedButton(
                      child: Text(lang.getString(
                          AppLocalizations.CLICK_TO_ADD_INTERVAL)),
                      onPressed: () {
                        _addIntervalDialog();
                      },
                    ));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIntervalDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
