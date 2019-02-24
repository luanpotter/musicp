class QueryResult {
  String id;
  String title;

  QueryResult();

  QueryResult.fromMap(Map<String, String> data) {
    this.id = data['id'];
    this.title = data['title'];
  }

  static QueryResult from(Map<String, String> data) {
    return QueryResult.fromMap(data);
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
