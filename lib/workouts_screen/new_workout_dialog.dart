import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewWorkoutDialog extends StatelessWidget {
  NewWorkoutDialog({Key key, this.onNewWorkoutConfirmed}) : super(key: key);

  final nameCtrl = TextEditingController();

  final void Function(String name) onNewWorkoutConfirmed;

  void _confirmWorkoutPressed() {
    onNewWorkoutConfirmed(nameCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              color: Theme.of(context).accentColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "New Workout",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Workout name',
                ),
              ),
            ),
            FlatButton(
                color: Colors.lightBlue,
                onPressed: _confirmWorkoutPressed,
                child: Text("Create workout"))
          ],
        ),
      ),
    );
  }
}
