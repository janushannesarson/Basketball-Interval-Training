import 'package:basketball_workouts/app_localizations.dart';
import 'package:basketball_workouts/settings_screen/settings_screen_view_model.dart';
import 'package:basketball_workouts/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          title: Text(lang.getString(AppLocalizations.SETTINGS)),
        ),
        body: FutureBuilder(
            future: SettingsScreenViewModel.newInstance(),
            builder: (buildContext, snapshot) {
              if (snapshot.hasData) {
                viewModel = snapshot.data;
                //need the themechanger so the user can change the team
                viewModel.themeChanger = Provider.of<ThemeChanger>(context);

                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(lang.getString(
                                AppLocalizations.TEXT_TO_SPEECH_ENABLED)),
                          ),
                          Switch(
                            value: viewModel.ttsEnabled,
                            onChanged: (enabled) {
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
                          Expanded(
                            child: Text(lang.getString(
                                AppLocalizations.TEXT_TO_SPEECH_VOLUME)),
                          ),
                          Slider(
                            value: viewModel.ttsVolume,
                            min: 0.0,
                            max: 1.0,
                            onChanged: !viewModel.ttsEnabled
                                ? null
                                : (volume) {
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
                          Expanded(
                              child: Text("Text to speech speed")),
                          Slider(
                            value: viewModel.speechRate,
                            onChanged: !viewModel.ttsEnabled
                                ? null
                                : (rate) {
                                    setState(() {
                                      viewModel.speechRate = rate;
                                    });
                                  },
                            divisions: 1,
                            min: 0.75,
                            max: 1,
                            label:
                                "${viewModel.speechRate == 0.75 ? "Slow" : "Normal"}",
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
