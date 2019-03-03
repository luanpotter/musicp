import 'package:flutter/material.dart';

import '../domain/enhanced_music.dart';
import '../domain/query.dart';
import '../screens/tag_widget.dart';
import '../state/app_state.dart';
import '../state/state_container.dart';
import 'play_control_widget.dart';
import 'scaffold_wrapper.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String error;
  Query query = Query.all();
  TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    queryController.addListener(this._handleChange);
  }

  _handleChange() {
    setState(() {
      this.query = Query.all();
      this.error = null;
    });
    String queryStr = queryController.text;
    try {
      setState(() => this.query = Query(queryStr));
    } catch (ex) {
      setState(() => this.error = 'Invalid query');
    }
  }

  _clickTag(String tag) {
    setState(() {
      if (queryController.text.isEmpty) {
        queryController.text = 'tag:$tag';
      } else {
        queryController.text = '${queryController.text} tag:$tag';
      }
    });
  }

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
        ]);
  }

  Widget _doBuild(BuildContext context, AppState state) {
    if (state.loading) {
      return _loading();
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _omniInput(context, state),
          _musicsList(context, state),
          Center(child: _tagsList(context, state)),
        ],
      ),
    );
  }

  Widget _musicsList(BuildContext context, AppState state) {
    return StreamBuilder(
      stream: state.enhancedMusics(),
      builder: (BuildContext context, AsyncSnapshot<List<EnhancedMusic>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
        List<EnhancedMusic> musicList = snapshot.data.where(query.getFilter()).toList();
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemExtent: 40.0,
            itemCount: musicList.length,
            itemBuilder: (ctx, idx) =>
                this._buildMusic(context, musicList[idx]),
            shrinkWrap: true,
          ),
        );
      },
    );
  }

  Widget _omniInput(BuildContext context, AppState state) {
    return Container(
      child: TextField(controller: queryController),
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
    );
  }

  Widget _tagsList(BuildContext context, AppState state) {
    Stream<List<String>> tagStream = state.dataset
        .musics()
        .map((m) => m.expand((m) => m.tags).toSet().toList()..sort());
    return StreamBuilder(
      stream: tagStream,
      builder: (BuildContext context, AsyncSnapshot<List<String>> data) {
        if (data.hasError) {
          return Text('Error: ${data.error}');
        }

        if (!data.hasData) {
          return Text('Loading...');
        }

        List<String> tags = data.data;
        return Row(
            children: tags
                .map((tag) => TagWidget(tag: tag, onClick: this._clickTag))
                .toList());
      },
    );
  }

  Widget _buildMusic(BuildContext context, EnhancedMusic music) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(music.music.desc),
          Row(
              children: music.music.tags
                  .map<Widget>((tag) => TagWidget(tag: tag, onClick: this._clickTag))
                  .toList()
                  ..add(PlayControlWidget(music: music))
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;
    return ScaffoldWrapper(
      state: appState,
      child: _doBuild(context, appState),
    );
  }
}
