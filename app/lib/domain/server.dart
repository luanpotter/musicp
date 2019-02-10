class Server {
  String id;
  String name;
  String protocol;
  String url;

  static from(String id, Map<String, String> data) {
    if (data == null) {
      return null;
    }
    Server m = Server();
    m.id = id;
    m.name = data['name'];
    m.protocol = data['protocol'];
    m.url = data['url'];
    return m;
  }
}
