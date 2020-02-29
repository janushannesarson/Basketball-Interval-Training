import 'package:basketball_workouts/home_screen/edit_workout_screen_view_model.dart';
import 'package:basketball_workouts/home_screen/new_interval_dialog.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';

class EditWorkoutScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;

  EditWorkoutScreen({Key key, this.workoutId, this.workoutName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  EditWorkoutScreenViewModel viewModel = EditWorkoutScreenViewModel();
  Future<List> intervals;

  @override
  void initState() {
    // TODO: implement initState
    intervals = viewModel.getIntervals(widget.workoutId);
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
      viewModel.addInterval(exercise, duration, rest, widget.workoutId);
      intervals = viewModel.getIntervals(widget.workoutId);
    });
  }

  void _onCreateWorkout() {}

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

          ),
        ),
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("${widget.workoutName}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            tooltip: "Create workout",
            onPressed: _onCreateWorkout,
          )
        ],
      ),
      body: FutureBuilder<List>(
        future: intervals,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            return ReorderableListView(
              onReorder: _onReorder,
              children: convertToCards(snapshot.data),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
//      ReorderableListView(
//        children: viewModel.intervals
//            .map((index) => Dismissible(
//                  key: ObjectKey(index),
//                  child: Card(
//                    elevation: 8,
//                    child: ListTile(
//                      title: Text("${index.description}"),
//                      subtitle: Text(
//                          "Duration: ${index.duration} seconds Rest: ${index.rest} seconds"),
//                      trailing: Icon(Icons.drag_handle),
//                    ),
//                  ),
//                ))
//            .toList(),
//        onReorder: _onReorder,
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIntervalDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
