import 'package:flutter/material.dart';

import 'state/state_container.dart';
import 'screens/main_screen.dart';

void main() => runApp(StateContainer(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'musicp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
