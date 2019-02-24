class Server {
  String id;
  String name;
  String protocol;
  String url;

  Server();

  Server.fromMap(Map<String, String> data) {
    this.name = data['name'];
    this.protocol = data['protocol'];
    this.url = data['url'];
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
    };
  }
}
