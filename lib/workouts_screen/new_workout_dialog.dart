import 'package:basketball_workouts/app_localizations.dart';
import 'package:flutter/material.dart';

class NewWorkoutDialog extends StatefulWidget {
  NewWorkoutDialog({Key key, this.onNewWorkoutConfirmed}) : super(key: key);

  final void Function(String name) onNewWorkoutConfirmed;

  @override
  _NewWorkoutDialogState createState() => _NewWorkoutDialogState();
}

class _NewWorkoutDialogState extends State<NewWorkoutDialog> {
  final nameCtrl = TextEditingController();

  var validName = false;

  void _confirmWorkoutPressed() {
    widget.onNewWorkoutConfirmed(nameCtrl.text);
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
                onChanged: (String string) {
                  setState(() {
                    validName = string.isNotEmpty;
                  });
                },
              ),
            ),
            FlatButton(
                color: Colors.lightBlue,
                disabledColor: Colors.grey,
                onPressed: validName ? _confirmWorkoutPressed : null,
                child: Text(lang.getString(AppLocalizations.CREATE_WORKOUT)))
          ],
        ),
      ),
    );
  }
}
