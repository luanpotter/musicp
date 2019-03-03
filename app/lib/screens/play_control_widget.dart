import 'package:flutter/material.dart';

import '../domain/enhanced_music.dart';
import '../domain/music_status.dart';
import '../state/app_state.dart';
import '../state/state_container.dart';

class PlayControlWidget extends StatelessWidget {

  final EnhancedMusic music;

  const PlayControlWidget({Key key, @required this.music }) : super(key: key);

  IconData icon(MusicStatus status) {
    switch (status) {
      case MusicStatus.LOADING:
        return Icons.cached;
      case MusicStatus.NOT_DOWNLOADED:
        return Icons.file_download;
      case MusicStatus.DOWNLOADING:
        return Icons.cached;
      case MusicStatus.DOWNLOADED:
        return Icons.play_arrow;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;
    return IconButton(
      icon: Icon(icon(music.status)),
      onPressed: () => music.click(appState),
    );
  }
}
