import 'package:musicp/state/app_state.dart';

import '../downloader.dart';
import '../files.dart';
import '../player.dart';
import 'download_state.dart';
import 'music.dart';
import 'music_status.dart';
import 'server.dart';

class EnhancedMusic {
  Music music;
  MusicStatus status;
  String filePathReference;
  Server server;

  static Future<EnhancedMusic> enhance(Music music, List<Server> servers, Map<String, DownloadState> states) async {
    EnhancedMusic m = EnhancedMusic();
    m.music = music;
    m.server = servers.firstWhere((s) => s.protocol == music.serverProtocol, orElse: null);
    m.filePathReference = await Files.getFileRef(music.id);
    bool exists = await Files.exists(music.id);

    DownloadState downloadState = states[music.id];
    bool isDownloading = downloadState != null && downloadState != DownloadState.FINISHED;

    if (m.server == null) {
      m.status = MusicStatus.LOADING;
    } else if (exists) {
      m.status = MusicStatus.DOWNLOADED;
    } else if (isDownloading) {
      m.status = MusicStatus.DOWNLOADING;
    } else {
      m.status = MusicStatus.NOT_DOWNLOADED;
    }

    return m;
  }

  void click(AppState appState) {
    if (status == MusicStatus.DOWNLOADED) {
      Player.play(appState, this);
    } else if (status == MusicStatus.NOT_DOWNLOADED) {
      Downloader.download(appState, server, music.id, music.serverId);
    } else {
      print('No action available');
    }
  }
}