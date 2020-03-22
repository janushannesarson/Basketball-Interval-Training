import 'package:basketball_workouts/catalog_screen/catalog_screen.dart';
import 'package:flutter/material.dart';

class NewIntervalDialog extends StatefulWidget {
  NewIntervalDialog({Key key, this.onAddConfirmed}) : super(key: key);

  final void Function(String exercise, int duration, int rest) onAddConfirmed;

  @override
  _NewIntervalDialogState createState() => _NewIntervalDialogState();
}

class _NewIntervalDialogState extends State<NewIntervalDialog> {
  final exerciseCtrl = TextEditingController();

  bool restError = false;

  double workPeriod = 10.0;

  double restPeriod = 10.0;

  void _addIntervalPressed(BuildContext context) {
    widget.onAddConfirmed(exerciseCtrl.text, workPeriod.toInt(),
        restPeriod.toInt());
    Navigator.of(context).pop();
  }

  void _exerciseCatalogPressed(BuildContext context) async {
    String chosenExercise = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new CatalogScreen()));

    exerciseCtrl.text = chosenExercise;
  }

  String _buildLabel(double seconds){
    String minString;
    String secString;

    int mins = seconds ~/ 60;
    int secs = (seconds % 60).toInt();

    if(mins < 10){
      minString = "0$mins";
    } else {
      minString = "$mins";
    }

    if(secs < 10){
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
              color: Theme
                  .of(context)
                  .accentColor,
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
                        setState(() {

                        });
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
            Icon(Icons.timer),
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
            Icon(Icons.beach_access),
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
                onPressed: exerciseCtrl.text.isEmpty ? null : () {
                  _addIntervalPressed(context);
                },
                child: Text("Add interval"))
          ],
        ),
      ),
    );
  }
}
