import 'package:musicp/domain/music.dart';

class Query {

  List<String> keywords = [];
  List<String> tags = [];

  Query.all() : this('');

  Query(String queryStr) {
    if (queryStr.isEmpty) {
      return;
    }
    List<String> bits = queryStr.split(' ');
    bits.forEach((bit) {
      if (!bit.contains(':')) {
        keywords.add(bit);
      } else if (bit.startsWith('tag:')) {
        String tag = bit.substring('tag:'.length);
        tags.add(tag);
      } else {
        throw 'Unknown query';
      }
    });
  }

  bool Function(Music) getFilter() {
    return (Music m) {
      bool matchKeywords = keywords.map((keyword) => m.name.toLowerCase().contains(keyword.toLowerCase())).fold(true, (a, b) => a && b);
      if (!matchKeywords) {
        return false;
      }

      bool matchTags = tags.map((tag) => m.tags.contains(tag)).fold(true, (a, b) => a && b);
      return matchTags;
    };
  }
}