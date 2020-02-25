import 'package:basketball_workouts/home_screen/new_interval_dialog.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> data = ["aa", "bb", "cc", "dd", "ee", "ff", "gg"];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final x = data.removeAt(oldIndex);
      data.insert(newIndex, x);
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
        children: data
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

  void _addIntervalDialog(){
    showDialog(context: context, child: NewIntervalDialog());
  }
}
