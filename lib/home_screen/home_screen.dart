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

  int _selectedIndex = 1;

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
    });
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCreateWorkout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Workout Editor"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            tooltip: "Create workout",
            onPressed: _onCreateWorkout,
          )
        ],
      ),
      body: ReorderableListView(
        children: viewModel.intervals
            .map((index) => Dismissible(
                  key: ObjectKey(index),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text("${index.title}"),
                      subtitle: Text(
                          "Duration: ${index.duration} seconds Rest: ${index.rest} seconds"),
                      trailing: Icon(Icons.drag_handle),
                    ),
                  ),
                ))
            .toList(),
        onReorder: _onReorder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIntervalDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add_box), title: Text("Workout Editor")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Workouts")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings"))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        )
      ,
    
    );
  }
}
