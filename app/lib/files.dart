import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Files {
  static Future<String> get _localPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> getFileRef(String musicId) async {
    String path = await _localPath;
    return '$path/$musicId.mp3';
  }

  static Future<bool> exists(String musicId) async {
    File file = await _getFile(musicId);
    return file.exists();
  }

  static Future saveContent(String musicId, String downloadUrl) async {
    File file = await _getFile(musicId);
    http.Request req = http.Request('GET', Uri.parse(downloadUrl));
    http.StreamedResponse resp = await req.send();
    await file.writeAsBytes(await resp.stream.toBytes());
  }

  static Future<File> _getFile(String musicId) async {
    return File(await getFileRef(musicId));
  }
}
