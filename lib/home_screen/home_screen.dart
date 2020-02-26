import 'package:basketball_workouts/home_screen/home_screen_view_model.dart';
import 'package:basketball_workouts/home_screen/new_interval_dialog.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeScreenViewModel viewModel = HomeScreenViewModel();

  void _onReorder(int oldIndex, int newIndex){
    setState(() {
      viewModel.onReorder(oldIndex, newIndex);
    });
  }

  void _addIntervalDialog() {
    showDialog(context: context, child: NewIntervalDialog(onAddConfirmed: _onAddConfirmed,));
  }

  void _onAddConfirmed(String exercise, int duration, int rest){
    setState(() {
      viewModel.addInterval(exercise, duration, rest);  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "Sort it",
            onPressed: _addIntervalDialog,
          )
        ],
      ),
      body: ReorderableListView(
        children: viewModel.intervals
            .map((index) => ListTile(
                  key: ObjectKey(index),
                  title: Text("$index"),
                  subtitle: Text("Move it"),
                ))
            .toList(),
        onReorder: _onReorder,
      ),
    );
  }

}
