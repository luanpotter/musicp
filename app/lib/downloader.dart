import 'dart:io';

import 'domain/download_state.dart';

import 'domain/download_result.dart';
import 'domain/server.dart';
import 'files.dart';
import 'state/app_state.dart';

class Downloader {

  static Future download(AppState state, Server server, String musicId, String id) async {
    state.downloading.emit(musicId, DownloadState.STARTED);
    print('Starting $id');
    DownloadResult result = await server.startDownload(id);
    print('Started ${result.downloadId}');
    String status = 'not-found';
    while (status == 'not-found' || status == 'pending') {
      status = await server.downloadStatus(result.downloadId);
      sleep(Duration(seconds: 2));
    }
    print('Status: $status');
    state.downloading.emit(musicId, DownloadState.DOWNLOADING);
    print('Done! Downloading from ${result.downloadUrl}');
    await Files.saveContent(musicId, result.downloadUrl);
    print('Done!!!');
    state.downloading.emit(musicId, DownloadState.FINISHED);
  }
}