import 'package:basketball_workouts/settings_screen/settings_screen_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: FutureBuilder(
            future: SettingsScreenViewModel.newInstance(),
            builder: (buildContext, snapshot) {
              if (snapshot.hasData) {
                viewModel = snapshot.data;

                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(child: Text("Text to speech enabled"),),
                          Switch(
                            value: viewModel.ttsEnabled,
                            onChanged: (enabled){
                              setState(() {
                                viewModel.ttsEnabled = enabled;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(child: Text("Text to speech volume"),),
                          Slider(
                            value: viewModel.ttsVolume,
                            min: 0.0,
                            max: 1.0,
                            onChanged: !viewModel.ttsEnabled ? null : (volume) {
                              setState(() {
                                viewModel.ttsVolume = volume;
                              });
                            },
                            divisions: 20,
                            label: "${(viewModel.ttsVolume * 100).toInt()}%",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(child: Text("Text to speech rate")),
                          Slider(
                            value: viewModel.speechRate,
                            onChanged: !viewModel.ttsEnabled ? null : (rate) {
                              setState(() {
                                viewModel.speechRate = rate;
                              });
                            },
                            divisions: 2,
                            min: 0.75,
                            max: 1.25,
                            label:
                                "${viewModel.speechRate == 0.75 ? "Slow" : viewModel.speechRate == 1 ? "Normal" : viewModel.speechRate == 1.25 ? "Fast" : viewModel.speechRate}",
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
