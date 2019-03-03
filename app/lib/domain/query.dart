import 'enhanced_music.dart';
import 'music.dart';

class Query {

  List<String> texts = [];
  List<String> tags = [];
  List<String> names = [];

  Query.all() : this('');

  Query(String queryStr) {
    if (queryStr.isEmpty) {
      return;
    }
    List<String> bits = queryStr.split(' ');
    bits.forEach((bit) {
      if (!bit.contains(':')) {
        texts.add(bit);
      } else if (bit.startsWith('tag:')) {
        _handleParseBit(tags, 'tag', bit);
      } else if (bit.startsWith('text:')) {
        _handleParseBit(texts, 'text', bit);
      } else if (bit.startsWith('name:')) {
        _handleParseBit(names, 'name', bit);
      } else {
        throw 'Unknown query';
      }
    });
  }

  void _handleParseBit(List<String> list, String key, String bit) {
    list.add(bit.substring('$key:'.length));
  }

  static String n(String t) {
    return (t ?? '').toLowerCase();
  }

  static bool cmp(String t1, String t2) {
    return n(t1).contains(n(t2));
  }

  bool Function(EnhancedMusic) getFilter() {
    return (EnhancedMusic em) {
      Music m = em.music;
      bool textMatch = texts.map((keyword) => cmp(m.artistId, keyword) || cmp(m.name, keyword)).fold(true, (a, b) => a && b);
      bool nameMatch = names.map((name) => cmp(m.name, name)).fold(true, (a, b) => a && b);
      bool matchTags = tags.map((tag) => m.tags.contains(tag)).fold(true, (a, b) => a && b);
      return textMatch && nameMatch && matchTags;
    };
  }
}