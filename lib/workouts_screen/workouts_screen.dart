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
  Future<List> workouts;

  @override
  void initState() {
    workouts = getWorkouts();

    super.initState();
  }

  Future<List<Workout>> getWorkouts() async {
    return viewModel.getWorkouts();
  }

  void _onNewWorkoutConfirmed(String name) {
    setState(() {
      viewModel.addWorkout(name);
      workouts = viewModel.getWorkouts();
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
            ));

    Navigator.push(
      context,
      routeToEditWorkoutScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Workouts"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onNewWorkoutPressed(context);
              })
        ],
      ),
      body: FutureBuilder<List>(
          future: workouts,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (buildContext, int index) {
                    return Dismissible(
                      key: Key(snapshot.data[index].id.toString()),
                      background: Container(
                        child: Center(child: Text("Delete workout")),
                        color: Colors.red,
                      ),
                      onDismissed: (direction) {
                        _deleteWorkout(snapshot.data[index].id);

                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text("${snapshot.data[index].name} deleted")));
                        snapshot.data.removeAt(index);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text((snapshot.data[index]).name),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  splashColor: Colors.amber,
                                  onPressed: () {
                                    _editWorkoutPressed(snapshot.data[index].id,
                                        snapshot.data[index].name, context);
                                  },
                                ),
                              ]),
                        ),
                        elevation: 5,
                        color: Colors.orange,
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
