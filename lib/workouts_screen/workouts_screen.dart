import 'package:basketball_workouts/home_screen/edit_workout_screen.dart';
import 'package:basketball_workouts/model/workout.dart';
import 'package:basketball_workouts/timer_screen/timer_screen.dart';
import 'package:basketball_workouts/workouts_screen/new_workout_dialog.dart';
import 'package:basketball_workouts/workouts_screen/workouts_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class WorkoutsScreen extends StatefulWidget {
  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  WorkoutsScreenViewModel viewModel = WorkoutsScreenViewModel();

  void _onNewWorkoutConfirmed(String name) {
    setState(() {
      viewModel.addWorkout(name);
      viewModel.getWorkouts();
    });
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  void _onNewWorkoutPressed(BuildContext context) {
    showDialog(
        context: context,
        child: NewWorkoutDialog(
          onNewWorkoutConfirmed: _onNewWorkoutConfirmed,
        ));
  }

  void _deleteWorkout(int id) {
    setState(() {
      viewModel.deleteWorkout(id);
    });
  }

  void _editWorkoutPressed(
      int id, String workoutName, BuildContext scaffoldContext) {
    var routeToEditWorkoutScreen = new MaterialPageRoute(
        builder: (BuildContext context) => new EditWorkoutScreen(
              workoutId: id,
              workoutName: workoutName,
              scaffoldContext: scaffoldContext,
              fetchWorkoutsCallBack: _fetchWorkoutsCallBack,
            ));

    Navigator.push(
      context,
      routeToEditWorkoutScreen,
    );
  }

  void _fetchWorkoutsCallBack() {
    setState(() {
      viewModel.getWorkouts();
    });
  }

  void _startWorkoutPressed(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                new TimerScreen(workout.intervals)));
  }

  Text buildDurationText(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    String minString = min.toString();
    String secString = sec.toString();

    if (min < 10) {
      minString = "0${min.toString()}";
    }

    if (sec < 10) {
      secString = "0${sec.toString()}";
    }

    return Text("Duration " + minString + ":" + secString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _onNewWorkoutPressed(context);
        },
      ),
      appBar: AppBar(
        title: Text("Your Workouts"),
      ),
      body: FutureBuilder<List>(
          future: viewModel.workouts,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (buildContext, int index) {
                    Workout workout = snapshot.data[index];
                    return Dismissible(
                      key: Key(workout.id.toString()),
                      background: Container(
                        child: Center(child: Text("Delete workout")),
                        color: Colors.red,
                      ),
                      onDismissed: (direction) {
                        _deleteWorkout(workout.id);

                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("${workout.name} deleted")));
                        snapshot.data.removeAt(index);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(workout.name),
                          subtitle: buildDurationText(
                              viewModel.workoutDurationInSeconds(workout)),
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
                                    _editWorkoutPressed(
                                        workout.id, workout.name, context);
                                  },
                                ),
                                IconButton(
                                  iconSize: 40,
                                  tooltip: "Start",
                                  color: Colors.green,
                                  icon: Icon(Icons.play_circle_filled),
                                  splashColor: Colors.amber,
                                  onPressed: workout.intervals.isEmpty ? null : () {
                                    _startWorkoutPressed(workout);
                                  },
                                ),
                              ]),
                        ),
                        elevation: 5,
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
