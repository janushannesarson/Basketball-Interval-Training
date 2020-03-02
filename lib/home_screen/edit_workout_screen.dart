import 'package:basketball_workouts/home_screen/edit_workout_screen_view_model.dart';
import 'package:basketball_workouts/home_screen/new_interval_dialog.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';

class EditWorkoutScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;
  final BuildContext scaffoldContext;

  EditWorkoutScreen({Key key, this.workoutId, this.workoutName, this.scaffoldContext})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  EditWorkoutScreenViewModel viewModel;
  Future<List> intervals;

  @override
  void initState() {
    // TODO: implement initState
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

    Scaffold.of(widget.scaffoldContext).showSnackBar(SnackBar(
        content:
        Text("Workout saved")));

  }

  List<Widget> convertToCards(List<WorkInterval> intervals) {
    List<Widget> result = new List();

    for (var interval in intervals) {
      result.add(Dismissible(
        key: Key(interval.id.toString()),
        onDismissed: (direction){

        },
        child: Card(
          child: ListTile(
            title: Text(interval.description),
            subtitle:
                Text("Duration: ${interval.duration} Rest: ${interval.rest}"),
            trailing: Icon(Icons.drag_handle),
          ),
        ),
      ));
    }

    return result;
  }

  Future<bool> _onBackPressed() async{
    viewModel.saveWorkout();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text("${widget.workoutName}"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.save),
//            tooltip: "Save workout",
//            onPressed: (){
//              _saveWorkoutPressed(context);
//            },
//          )
        ],
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
