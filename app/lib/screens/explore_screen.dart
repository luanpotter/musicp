import 'package:flutter/material.dart';
import 'package:musicp/domain/server.dart';

import '../state/app_state.dart';
import '../state/state_container.dart';
import 'scaffold_wrapper.dart';

class ExploreScreen extends StatefulWidget {
  @override
  ExploreScreenState createState() {
    return new ExploreScreenState();
  }
}

class ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;
    return ScaffoldWrapper(
      state: appState,
      child: _doBuild(context, appState),
    );
  }

  Widget _doBuild(BuildContext context, AppState appState) {
    return Column(
      children: [
        Container(
            child: this._header(context, appState),
            padding: EdgeInsets.all(8.0)),
        Container(
            child: this._results(context, appState),
            padding: EdgeInsets.all(8.0)),
      ],
    );
  }

  Widget _header(BuildContext context, AppState appState) {
    return Row(
      children: [
        Expanded(child: TextField(controller: textController)),
        Row(
          children: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.add), onPressed: () {}),
          ],
        )
      ],
    );
  }

  Widget _results(BuildContext context, AppState appState) {
    return StreamBuilder(
      stream: appState.dataset.servers(),
      builder: (BuildContext context, AsyncSnapshot<List<Server>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
        List<Server> serverList = snapshot.data;
        if (serverList.isEmpty) {
          return Text(
              'No servers found. You must add servers in order to find music.');
        }
        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemExtent: 80.0,
          itemCount: serverList.length,
          itemBuilder: (ctx, idx) =>
              this._buildServer(context, serverList[idx]),
          shrinkWrap: true,
        );
      },
    );
  }

  Widget _buildServer(BuildContext context, Server server) {
    return Text(server.name);
  }
}
