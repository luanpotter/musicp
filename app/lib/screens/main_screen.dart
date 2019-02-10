import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../state/state_container.dart';

class MainScreen extends StatefulWidget {
  MainScreen({ Key key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('musicp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Loading: ${appState.loading}'),
            Text('User: ${appState.user.user?.displayName}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
