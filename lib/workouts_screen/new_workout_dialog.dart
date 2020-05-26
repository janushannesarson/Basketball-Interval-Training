import 'package:basketball_workouts/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class NewWorkoutDialog extends StatefulWidget {
  final List takenNames;
  final void Function(String name) onNewWorkoutConfirmed;
  final BuildContext actualContext;

  NewWorkoutDialog(
      {Key key,
      this.takenNames,
      this.onNewWorkoutConfirmed,
      this.actualContext})
      : super(key: key);

  @override
  _NewWorkoutDialogState createState() => _NewWorkoutDialogState();
}

class _NewWorkoutDialogState extends State<NewWorkoutDialog> {
  final nameCtrl = TextEditingController();

  var validName = false;

  void _confirmWorkoutPressed() {
    widget.onNewWorkoutConfirmed(nameCtrl.text);
  }

  verifyName(String string) {
    validName = string.isNotEmpty && !widget.takenNames.contains(string);
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final theme = Theme.of(widget.actualContext);
    final dark = theme.brightness == Brightness.dark;

    return Dialog(
      child: Container(
        color: dark ? theme.backgroundColor : Colors.white,
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    lang.getString(AppLocalizations.NEW_WORKOUT),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black
                ),
                controller: nameCtrl,
                decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: dark ? Colors.white : theme.primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: dark ? Colors.white : theme.primaryColor, width: 2.0),
                    ),
                    labelText: lang.getString(AppLocalizations.WORKOUT_NAME),
                    labelStyle:
                        TextStyle(color: dark ? Colors.white : theme.primaryColor)),
                onChanged: (String string) {
                  setState(() {
                    verifyName(string);
                  });
                },
              ),
            ),
            RaisedButton(
                color: Theme.of(widget.actualContext).accentColor,
                onPressed: validName ? _confirmWorkoutPressed : null,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                child: Text(
                  lang.getString(AppLocalizations.CREATE_WORKOUT),
                  style: TextStyle(color: dark ? Colors.black : Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
