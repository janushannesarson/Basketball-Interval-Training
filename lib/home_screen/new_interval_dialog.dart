import 'package:basketball_workouts/catalog_screen/catalog_screen.dart';
import 'package:basketball_workouts/model/work_interval.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class NewIntervalDialog extends StatelessWidget {
  NewIntervalDialog({Key key, this.onAddConfirmed}) : super(key: key);

  final exerciseCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final restCtrl = TextEditingController();

  //test comment
  final void Function(String exercise, int duration, int rest) onAddConfirmed;

  void _addIntervalPressed(BuildContext context) {
    onAddConfirmed(exerciseCtrl.text, int.parse(durationCtrl.text),
        int.parse(restCtrl.text));
    Navigator.of(context).pop();
  }

  void _exerciseCatalogPressed(BuildContext context) async {
    String chosenExercise = await Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => new CatalogScreen()
    ));

    exerciseCtrl.text = chosenExercise;
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Exercise',
                      ),
                    ),
                  ),
                  Container(padding: EdgeInsets.all(5), child: RaisedButton(
                    child: Text("Catalog"), onPressed: () =>
                  {
                    _exerciseCatalogPressed(context)
                  },))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: durationCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Work duration in seconds',
                ),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: restCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rest in seconds',
                ),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            FlatButton(
                color: Colors.lightBlue,
                onPressed: () {
                  _addIntervalPressed(context);
                },
                child: Text("Add interval"))
          ],
        ),
      ),
    );
  }
}
