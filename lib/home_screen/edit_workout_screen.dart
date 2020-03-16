import 'package:basketball_workouts/home_screen/edit_workout_screen_view_model.dart';
import 'package:basketball_workouts/home_screen/new_interval_dialog.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:basketball_workouts/timer_screen/timer_screen.dart';
import 'package:flutter/material.dart';

class EditWorkoutScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;
  final BuildContext scaffoldContext;
  final void Function() fetchWorkoutsCallBack;

  EditWorkoutScreen(
      {Key key, this.fetchWorkoutsCallBack, this.workoutId, this.workoutName, this.scaffoldContext})
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
          onAddConfirmed: _onAddConfirmed,
        ));
  }

  void _onAddConfirmed(String exercise, int duration, int rest) {
    setState(() {
      viewModel.addInterval(exercise, duration, rest);
      intervals = viewModel.getIntervals();
    });
  }

  void _saveWorkoutPressed(BuildContext context) {
    viewModel.saveWorkout();
    Navigator.pop(context);

    Scaffold.of(widget.scaffoldContext)
        .showSnackBar(SnackBar(content: Text("Workout saved")));
  }

  void _deleteInterval(WorkInterval interval) {
    setState(() {
      viewModel.deleteInterval(interval);
    });
  }

  List<Widget> convertToCards(List<WorkInterval> intervals) {
    List<Widget> result = new List();

    for (var interval in intervals) {
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
              title: Text(interval.description),
              subtitle:
                  Text("Duration: ${interval.duration} Rest: ${interval.rest}"),
              trailing: Icon(Icons.drag_handle),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.workoutName}"),
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
              return ReorderableListView(
                onReorder: _onReorder,
                children: convertToCards(snapshot.data),
              );
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
