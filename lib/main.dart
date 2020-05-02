import 'package:basketball_workouts/app_localizations.dart';
import 'package:basketball_workouts/settings_screen/settings_screen.dart';
import 'package:basketball_workouts/theme.dart';
import 'package:basketball_workouts/workouts_screen/workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('es')
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ThemeChanger.getInstance(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ChangeNotifierProvider<ThemeChanger>(
            create: (_) => snapshot.data as ThemeChanger,
            child: new MaterialAppWithTheme(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class MaterialAppWithTheme extends StatefulWidget {
  @override
  _MaterialAppWithThemeState createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _callScreen() {
    switch (_selectedIndex) {
      case 0:
        return WorkoutsScreen();
      case 1:
        return SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      theme: theme.getTheme(),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('es')],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      home: Scaffold(
        body: _callScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(lang.getString(AppLocalizations.YOUR_WORKOUTS))),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text(lang.getString(AppLocalizations.SETTINGS)))
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
