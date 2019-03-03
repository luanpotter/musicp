import '../domain/enhanced_music.dart';
import 'dataset_state.dart';
import 'downloading_state.dart';
import 'enhanced_music_stream.dart';
import 'user_state.dart';

class AppState {

  bool loading = false;
  UserState user = UserState();
  DatasetState dataset = DatasetState();
  DownloadingState downloading = DownloadingState();

  Stream<List<EnhancedMusic>> enhancedMusics() {
    return EnhancedMusicStream(dataset.servers(), dataset.musics(), downloading.stream()).stream();
  }

  dispose() {
    downloading.dispose();
  }
}