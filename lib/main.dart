import 'package:basketball_workouts/home_screen/home_screen.dart';
import 'package:basketball_workouts/settings_screen/settings_screen.dart';
import 'package:basketball_workouts/workouts_screen/workouts_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _callScreen(){
    switch(_selectedIndex){
      case 0: return WorkoutsScreen();
      case 1: return SettingsScreen();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _callScreen(),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Workouts")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings"))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        )
      ,
      ),
    );
  }
}