class DownloadResult {
  String downloadId;
  String downloadUrl;

  DownloadResult();

  DownloadResult.fromMap(Map<String, String> data) {
    this.downloadId = data['downloadId'];
    this.downloadUrl = data['downloadUrl'];
  }

  static DownloadResult from(Map<String, String> data) {
    return DownloadResult.fromMap(data);
  }

  Map<String, String> toMap() {
    return {
      'downloadId': downloadId,
      'downloadUrl': downloadUrl,
    };
  }
}