import 'package:flutter/material.dart';

import '../domain/server.dart';
import '../state/app_state.dart';
import '../state/state_container.dart';
import 'add_server_modal.dart';
import 'scaffold_wrapper.dart';

class ServersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;
    return ScaffoldWrapper(
      state: appState,
      child: _doBuild(context, appState),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => this._addServerModal(context),
      ),
    );
  }

  void _addServerModal(BuildContext context) {
    showDialog(context: context, builder: this.renderDialog);
  }

  SimpleDialog renderDialog(BuildContext context) {
    return SimpleDialog(children: [AddServerModal()]);
  }

  Widget _doBuild(BuildContext context, AppState appState) {
    return Container(
      child: this._results(context, appState),
      padding: EdgeInsets.all(8.0),
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
          return Text('No servers found.');
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
