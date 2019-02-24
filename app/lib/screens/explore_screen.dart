import 'package:flutter/material.dart';

import '../domain/music.dart';
import '../domain/query_result.dart';
import '../domain/server.dart';
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

  List<QueryResult> results = [];
  int selectedServerIdx = 0;

  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;
    return ScaffoldWrapper(
      state: appState,
      child: _doBuild(context, appState),
    );
  }

  void _changeSelectedServer(BuildContext context, List<Server> serverList) {
    print('TODO change selection dialog...');
    List<Widget> Function() children = () {
      List<Widget> ls = [];
      ls.add(Text('Select a server to query from:'));
      ls.addAll(serverList.map((s) => GestureDetector(
          child: Text(s.name),
          onTap: () {
            int idx = serverList.indexOf(s);
            Navigator.of(context).pop();
            setState(() {
              results = [];
              selectedServerIdx = idx;
            });
          })));
      return ls;
    };
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            children: [
              Container(
                child: Column(
                  children: children()
                      .map((el) =>
                          Container(child: el, padding: EdgeInsets.all(4.0)))
                      .toList(),
                ),
                padding: EdgeInsets.all(4.0),
              ),
            ],
          ),
    );
  }

  void _doQuery(Server server, String search) async {
    List<QueryResult> rs = await server.query(search);
    setState(() => results = rs);
  }

  void _addSong(BuildContext context, Server server, QueryResult song) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            children: [
              Container(
                child: Column(children: [
                  Text('Would you like to add this song to your collection?'),
                  Text('URL: ${server.protocol}://${song.id}'),
                  Text('Title: ${song.title}'),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton.icon(
                          icon: Icon(Icons.cancel),
                          label: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton.icon(
                          icon: Icon(Icons.check),
                          label: Text('Add to collection'),
                          onPressed: () =>
                              this._doAddSong(context, server, song),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
    );
  }

  void _doAddSong(BuildContext context, Server server, QueryResult song) async {
    AppState appState = StateContainer.of(context).state;

    Music m = Music();
    m.name = song.title;
    m.source = '${server.protocol}://${song.id}';

    await appState.dataset.createMusic(m);
    Navigator.of(context).pop();
  }

  Widget _header(BuildContext context, List<Server> serverList) {
    Server selectedServer = serverList[selectedServerIdx];
    var handler = () => this._doQuery(selectedServer, textController.text);
    return Row(
      children: [
        Container(
          child: GestureDetector(
            child: Text(selectedServer.name),
            onTap: () => this._changeSelectedServer(context, serverList),
          ),
          padding: EdgeInsets.only(right: 8.0),
        ),
        Expanded(
          child: TextField(
            controller: textController,
            onSubmitted: (_) => handler(),
          ),
        ),
        IconButton(icon: Icon(Icons.search), onPressed: handler),
      ],
    );
  }

  Widget _results(
      BuildContext context, Server server, List<QueryResult> results) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemExtent: 40.0,
        itemCount: results.length,
        itemBuilder: (ctx, idx) =>
            this._buildResult(context, server, results[idx]),
        shrinkWrap: true,
      ),
    );
  }

  Widget _doBuild(BuildContext context, AppState appState) {
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
        return Column(
          children: [
            Container(
              child: this._header(context, serverList),
              padding: EdgeInsets.all(8.0),
            ),
            this._results(context, serverList[selectedServerIdx], this.results),
          ],
        );
      },
    );
  }

  Widget _buildResult(BuildContext context, Server server, QueryResult result) {
    return GestureDetector(
      child: Text(result.title),
      onTap: () => this._addSong(context, server, result),
    );
  }
}
