import 'dart:convert';

import 'package:http/http.dart' as http;

import 'download_result.dart';
import 'query_result.dart';

class Server {
  String id;
  String name;
  String protocol;
  String url;
  String headerName;
  String headerValue;

  Server();

  Server.fromMap(Map<String, String> data) {
    this.name = data['name'];
    this.protocol = data['protocol'];
    this.url = data['url'];
    this.headerName = data['headerName'];
    this.headerValue = data['headerValue'];
  }

  static from(String id, Map<String, String> data) {
    if (data == null) {
      return null;
    }
    return Server.fromMap(data)..id = id;
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'protocol': protocol,
      'url': url,
      'headerName': headerName,
      'headerValue': headerValue,
    };
  }

  Future<List<QueryResult>> query(String param) async {
    String q = Uri.encodeQueryComponent(param);
    String jsonStr = await _getRequest('$url/query?q=$q');
    List<dynamic> decoded = json.decode(jsonStr);
    return decoded.map((obj) => QueryResult.from((obj as Map).cast())).toList();
  }

  Future<DownloadResult> startDownload(String id) async {
    String q = Uri.encodeQueryComponent(id);
    String jsonStr = await _getRequest('$url/download?id=$q');
    Map decoded = json.decode(jsonStr);
    return DownloadResult.fromMap(decoded.cast());
  }

  Future<String> downloadStatus(String downloadId) async {
    String q = Uri.encodeQueryComponent(downloadId);
    String jsonStr = await _getRequest('$url/status?downloadId=$q');
    Map decoded = json.decode(jsonStr);
    return decoded['status'];
  }

  Future<String> _getRequest(String url) async {
    http.Request req = http.Request('GET', Uri.parse(url));
    req.headers[headerName] = headerValue;
    http.StreamedResponse resp = await req.send();
    return String.fromCharCodes(await resp.stream.toBytes());
  }
}
