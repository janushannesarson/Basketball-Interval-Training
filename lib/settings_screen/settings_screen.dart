import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget{
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Column(
        children: <Widget>[
          DropdownButton(
            value: _value,
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                value: "2",
                child: Text("je"),
              )
            ],
            onChanged: (_value) {
              _value = _value;
            },
          )
        ],
      ),
    );
  }
}