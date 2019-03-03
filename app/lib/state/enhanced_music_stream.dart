import 'package:async/async.dart';
import 'package:musicp/domain/enhanced_music.dart';

import '../domain/download_state.dart';
import '../domain/music.dart';
import '../domain/server.dart';

class EnhancedMusicStream {
  final Stream<List<Server>> serversStream;
  final Stream<List<Music>> musicsStream;
  final Stream<Map<String, DownloadState>> statesStream;

  List<Server> latestServers;
  List<Music> latestMusics;
  Map<String, DownloadState> latestStates;

  EnhancedMusicStream(this.serversStream, this.musicsStream, this.statesStream);

  Stream<List<EnhancedMusic>> stream() {
    Stream group = StreamGroup.merge([serversStream, musicsStream, statesStream]);
    return group.asyncMap((singleSnap) async {
      if (singleSnap is Map<String, DownloadState>) {
        latestStates = singleSnap;
      } else if (singleSnap is List<Server>) {
        latestServers = singleSnap;
      } else {
        latestMusics = singleSnap;
      }
      if (latestServers == null || latestMusics == null || latestStates == null) {
        return null;
      }
      List<Future<EnhancedMusic>> ems = latestMusics.map((m) => EnhancedMusic.enhance(m, latestServers, latestStates)).toList().cast();
      return await Future.wait(ems);
    });
  }
}