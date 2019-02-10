import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicp/domain/music.dart';

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

    return Column(children: [
      _helloMessage(state),
      Text('Musics'),
      _musicsList(state),
    ]);
  }

  Widget _musicsList(AppState state) {
    return StreamBuilder(
      stream: state.dataset.musics(),
      builder: (BuildContext context, AsyncSnapshot<List<Music>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
        return Expanded(child: ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.length,
          itemBuilder: (ctx, idx) => this._buildMusic(snapshot.data[idx]),
          shrinkWrap: true,
        ));
      },
    );
  }

  Widget _buildMusic(Music music) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(music.desc),
          Text(music.tags.join(', ')),
        ],
      ),
    );
  }

  Widget _helloMessage(AppState state) {
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
              if (doc.data == null) {
                return Text('Loading...');
              }

              String datasetId = doc.documentID;
              String datasetName = doc.data['name'];
              return Text('Current Collection: $datasetName (id: $datasetId)');
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
