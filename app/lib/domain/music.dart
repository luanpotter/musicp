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
    m.tags = (data['tags'] as List ?? []).cast();
    return m;
  }

  String get desc {
    String artist = artistId == null ? '' : ' ($artistId)';
    return '$name$artist';
  }

  List<String> get _sourceParts => source.split('://');
  String get serverProtocol => _sourceParts.first;
  String get serverId => _sourceParts.last;

  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'artistId': artistId,
      'source': source,
      'tags': tags?.join(','), // TODO better test this!!!
    };
  }
}
