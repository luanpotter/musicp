import 'package:audioplayers/audioplayers.dart';

import 'domain/enhanced_music.dart';
import 'state/app_state.dart';

class Player {
  static AudioPlayer player = AudioPlayer()..setReleaseMode(ReleaseMode.RELEASE);

  static void play(AppState appState, EnhancedMusic music) {
    player.play(music.filePathReference, isLocal: true);
  }
}
