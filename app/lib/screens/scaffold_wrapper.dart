import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicp/state/app_state.dart';

class ScaffoldWrapper extends StatelessWidget {
  final AppState state;
  final Widget child;

  ScaffoldWrapper({@required this.state, @required this.child});

  Widget _helloMessage() {
    if (state.loading) {
      return Text('Loading...');
    }
    return Column(
      children: [
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
            if (doc.data == null) {
              return Text('Loading...');
            }

            String datasetId = doc.documentID;
            String datasetName = doc.data['name'];
            return Column(children: [
              Text('Hi, ${state.user.user.displayName}!'),
              Text('Current Collection: $datasetName\n(id: $datasetId)'),
            ]);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('musicp'),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          Center(
              child: Text('musicp', style: Theme.of(context).textTheme.title)),
          _helloMessage(),
          Divider(),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.of(context).pushNamed('/'),
          ),
          ListTile(
            title: Text('Lists'),
            onTap: () => Navigator.of(context).pushNamed('/lists'),
          ),
        ],
      )),
      body: Center(child: child),
    );
  }
}
