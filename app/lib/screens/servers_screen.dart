import 'package:flutter/material.dart';

import '../domain/server.dart';
import '../state/app_state.dart';
import '../state/state_container.dart';
import 'scaffold_wrapper.dart';

class ServersScreen extends StatelessWidget {
  final TextEditingController addServerUrlController = TextEditingController();

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
    addServerUrlController.text = '';
    showDialog(context: context, builder: this.renderDialog);
  }

  void _addNewServer() {
    // TODO
  }

  SimpleDialog renderDialog(BuildContext context) {
    return SimpleDialog(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Server Url: '),
                  Expanded(
                      child: TextField(controller: addServerUrlController)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: Icon(Icons.cancel), onPressed: () => Navigator.of(context).pop()),
                  IconButton(icon: Icon(Icons.check), onPressed: () => this._addNewServer()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
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
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemExtent: 80.0,
            itemCount: serverList.length,
            itemBuilder: (ctx, idx) =>
                this._buildServer(context, serverList[idx]),
            shrinkWrap: true,
          ),
        );
      },
    );
  }

  Widget _buildServer(BuildContext context, Server server) {
    return Text(server.name);
  }
}
