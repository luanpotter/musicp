import 'dart:async';

import '../domain/download_state.dart';

class DownloadingState {
  Map<String, DownloadState> currentState = {};

  StreamController<Map<String, DownloadState>> _controller = StreamController();

  DownloadingState() {
    _controller.sink.add(currentState);
  }

  void emit(String musicId, DownloadState state) {
    currentState[musicId] = state;
    _controller.sink.add(currentState);
  }

  Stream<Map<String, DownloadState>> stream() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}