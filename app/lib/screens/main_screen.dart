import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../state/state_container.dart';

class MainScreen extends StatefulWidget {
  MainScreen({ Key key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget _loading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
        Text('Loading...'),
      ]
    );
  }

  Widget _doBuild(AppState state) {
    if (state.loading) {
      return _loading();
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hi, ${state.user.user.displayName}!'),
          StreamBuilder(
            stream: state.dataset.ref.snapshots(),
            builder: (context, data) {
              if (data.hasError) {
                return Text('Error: ${data.error}');
              }
              if (!data.hasData) {
                return Text('Loading...');
              }
              DocumentSnapshot doc = data.data as DocumentSnapshot;
              return Column(children: doc.data.keys.map((k) => Text(doc.data[k])).toList());
            },
          ),
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('musicp'),
      ),
      body: Center(child: _doBuild(appState)),
    );
  }
}
