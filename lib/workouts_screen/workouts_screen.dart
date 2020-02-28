import 'package:basketball_workouts/home_screen/home_screen.dart';
import 'package:basketball_workouts/model/workout.dart';
import 'package:basketball_workouts/workouts_screen/new_workout_dialog.dart';
import 'package:basketball_workouts/workouts_screen/workouts_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _onNewWorkoutConfirmed(String name){
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
            if(snapshot.hasError){
              return Container();
            } else if(snapshot.hasData){
              return ListView.builder(itemCount: snapshot.data.length ,itemBuilder: (BuildContext, int index){
                return ListTile(title: Text((snapshot.data[index]).name));
              });
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          }),
    );
  }
}
