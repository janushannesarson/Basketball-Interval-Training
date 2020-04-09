import 'package:basketball_workouts/app_localizations.dart';
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
    final lang = AppLocalizations.of(context);

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
                    lang.getString(AppLocalizations.NEW_WORKOUT),
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
                  labelText: lang.getString(AppLocalizations.WORKOUT_NAME),
                ),
              ),
            ),
            FlatButton(
                color: Colors.lightBlue,
                onPressed: _confirmWorkoutPressed,
                child: Text(lang.getString(AppLocalizations.CREATE_WORKOUT)))
          ],
        ),
      ),
    );
  }
}
