import 'package:flutter/material.dart';

import 'screens/explore_screen.dart';
import 'screens/main_screen.dart';
import 'screens/servers_screen.dart';
import 'state/state_container.dart';

void main() => runApp(StateContainer(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'musicp',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MainScreen(),
      routes: {
        '/explore': (context) => ExploreScreen(),
        '/servers': (context) => ServersScreen(),
      },
    );
  }
}
