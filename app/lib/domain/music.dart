class Music {

  String id;
  String name;
  String artistId;
  String source;
  List<String> tags;

  static from(String id, Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    Music m = Music();
    m.id = id;
    m.name = data['name'];
    m.artistId = data['artistId'];
    m.source = data['source'];
    m.tags = (data['tags'] as List).cast();
    return m;
  }

  String get desc {
    String artist = artistId == null ? '' : ' ($artistId)';
    return '$name$artist';
  }
}