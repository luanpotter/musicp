class Music {

  String name;
  String author;

  static from(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    Music m = Music();
    m.name = data['name'];
    m.author = data['author'];
    return m;
  }
}