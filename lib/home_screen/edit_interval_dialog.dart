import 'package:basketball_workouts/catalog_screen/catalog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';

class EditIntervalDialog extends StatefulWidget {
  final BuildContext actualContext;
  final int intervalId;
  final String exercise;
  final int duration;
  final int rest;
  final void Function(int intervalId, String exercise, int duration, int rest)
      onSaveConfirmed;

  EditIntervalDialog(
      {Key key,
        @required this.actualContext,
        @required this.onSaveConfirmed,
        @required this.intervalId,
        @required this.exercise,
        @required this.duration,
        @required this.rest})
      : super(key: key);

  @override
  _EditIntervalDialogState createState() => _EditIntervalDialogState();
}

class _EditIntervalDialogState extends State<EditIntervalDialog> {
  final exerciseCtrl = TextEditingController();

  double workPeriod;

  double restPeriod;

  @override
  void initState() {
    exerciseCtrl.text = widget.exercise;
    workPeriod = widget.duration.toDouble();
    restPeriod = widget.rest.toDouble();
  }

  void _saveChangesPressed(BuildContext context) {
    widget.onSaveConfirmed(widget.intervalId, exerciseCtrl.text,
        workPeriod.toInt(), restPeriod.toInt());
    Navigator.of(context).pop();
  }

  void _exerciseCatalogPressed(BuildContext context) async {
    String chosenExercise = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new CatalogScreen()));

    setState(() {
      exerciseCtrl.text = chosenExercise;
    });
  }

  String _buildLabel(double seconds) {
    String minString;
    String secString;

    int mins = seconds ~/ 60;
    int secs = (seconds % 60).toInt();

    if (mins < 10) {
      minString = "0$mins";
    } else {
      minString = "$mins";
    }

    if (secs < 10) {
      secString = "0$secs";
    } else {
      secString = "$secs";
    }

    return "$minString:$secString";
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(widget.actualContext);
    final theme = Theme.of(widget.actualContext);
    final dark = theme.brightness == Brightness.dark;
    final textColor = dark ? Colors.white : Colors.black;
    final buttonTextColor = dark ? Colors.black : Colors.white;

    return Dialog(
      backgroundColor: dark ? theme.backgroundColor : Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              color: theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Edit Interval",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      maxLength: 50,
                      style: TextStyle(color: textColor),
                      controller: exerciseCtrl,
                      onChanged: (string) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: dark ? Colors.white : theme.primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: dark ? Colors.white : theme.primaryColor,
                            ),
                          ),
                          labelText: lang.getString(AppLocalizations.EXERCISE),
                          labelStyle: TextStyle(
                            color: dark ? Colors.white : theme.primaryColor,
                          )),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: RaisedButton(
                        color: theme.accentColor,
                        child: Text(lang.getString(AppLocalizations.SUGGESTIONS)),
                        onPressed: () => {_exerciseCatalogPressed(context)},
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: theme.accentColor,
                  mini: true,
                  child: Icon(
                    Icons.exposure_neg_1,
                    color: buttonTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (workPeriod > 10) {
                        workPeriod--;
                      }
                    });
                  },
                ),
                Icon(
                  Icons.timer,
                  color: textColor,
                  size: 40,
                ),
                FloatingActionButton(
                  backgroundColor: theme.accentColor,
                  mini: true,
                  child: Icon(
                    Icons.exposure_plus_1,
                    color: buttonTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (workPeriod < 300) {
                        workPeriod++;
                      }
                    });
                  },
                ),
              ],
            ),
            Text(_buildLabel(workPeriod),
                style: TextStyle(fontSize: 30, color: textColor)),
            SliderTheme(
              data: theme.sliderTheme,
              child: Slider(
                value: workPeriod,
                divisions: 290,
                label: _buildLabel(workPeriod),
                onChanged: (value) {
                  setState(() {
                    workPeriod = value;
                  });
                },
                min: 10,
                max: 300,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: theme.accentColor,
                  mini: true,
                  child: Icon(
                    Icons.exposure_neg_1,
                    color: buttonTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (restPeriod > 10) {
                        restPeriod--;
                      }
                    });
                  },
                ),
                Icon(
                  Icons.beach_access,
                  color: textColor,
                  size: 40,
                ),
                FloatingActionButton(
                  backgroundColor: theme.accentColor,
                  mini: true,
                  child: Icon(
                    Icons.exposure_plus_1,
                    color: buttonTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (restPeriod < 300) {
                        restPeriod++;
                      }
                    });
                  },
                ),
              ],
            ),
            Text(
              _buildLabel(restPeriod),
              style: TextStyle(fontSize: 30, color: textColor),
            ),
            SliderTheme(
              data: theme.sliderTheme,
              child: Slider(
                value: restPeriod,
                divisions: 290,
                label: _buildLabel(restPeriod),
                onChanged: (value) {
                  setState(() {
                    restPeriod = value;
                  });
                },
                min: 10,
                max: 300,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    disabledColor: Colors.blueGrey,
                    color: theme.accentColor,
                    onPressed: exerciseCtrl.text.isEmpty
                        ? null
                        : () {
                      _saveChangesPressed(context);
                    },
                    child: Text("Save changes")),
                FlatButton(
                  disabledColor: Colors.blueGrey,
                  color: theme.accentColor,
                  child: Text("Cancel"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
