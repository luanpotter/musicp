import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/music.dart';

class DatasetState {
  DocumentReference ref;

  Stream<List<Music>> musics() {
    return ref.collection('musics').snapshots().map((docs) => (docs.documents ?? []).map((doc) => Music.from(doc.data)).toList().cast());
  }
}