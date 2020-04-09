import 'package:basketball_workouts/catalog_screen/catalog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditIntervalDialog extends StatefulWidget {
  EditIntervalDialog(
      {Key key,
      @required this.onSaveConfirmed,
      @required this.intervalId,
      @required this.exercise,
      @required this.duration,
      @required this.rest})
      : super(key: key);

  final int intervalId;
  final String exercise;
  final int duration;
  final int rest;
  final void Function(int intervalId, String exercise, int duration, int rest)
      onSaveConfirmed;

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
    return Dialog(
      child: SingleChildScrollView(
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
                    "New interval",
                    style: TextStyle(fontSize: 20),
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
                      controller: exerciseCtrl,
                      onChanged: (string) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Exercise',
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: RaisedButton(
                        child: Text("Catalog"),
                        onPressed: () => {_exerciseCatalogPressed(context)},
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exposure_neg_1,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      if (workPeriod > 10) {
                        workPeriod--;
                      }
                    });
                  },
                ),
                Icon(Icons.timer),
                IconButton(
                  icon: Icon(
                    Icons.exposure_plus_1,
                    color: Colors.black,
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
            Text(_buildLabel(workPeriod)),
            Slider(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exposure_neg_1,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      if (restPeriod > 10) {
                        restPeriod--;
                      }
                    });
                  },
                ),
                Icon(Icons.beach_access),
                IconButton(
                  icon: Icon(
                    Icons.plus_one,
                    color: Colors.black,
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
            Text(_buildLabel(restPeriod)),
            Slider(
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
            FlatButton(
                disabledColor: Colors.blueGrey,
                color: Colors.lightBlue,
                onPressed: exerciseCtrl.text.isEmpty
                    ? null
                    : () {
                        _saveChangesPressed(context);
                      },
                child: Text("Save changes"))
          ],
        ),
      ),
    );
  }
}
