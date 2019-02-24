import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/music.dart';
import '../domain/server.dart';

class DatasetState {
  DocumentReference ref;

  Stream<List<Music>> musics() {
    return ref.collection('musics').snapshots().map((docs) =>
        (docs.documents ?? [])
            .map((doc) => Music.from(doc.documentID, doc.data.cast()))
            .toList()
            .cast());
  }

  Stream<List<Server>> servers() {
    return ref.collection('servers').snapshots().map((docs) =>
        (docs.documents ?? [])
            .map((doc) => Server.from(doc.documentID, doc.data.cast()))
            .toList()
            .cast());
  }

  Future<DocumentReference> createServer(Server server) {
    return ref.collection('servers').add(server.toMap());
  }
}
