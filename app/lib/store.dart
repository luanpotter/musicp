import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Store {

  static Future<DocumentReference> fetchDatasetReference(FirebaseUser user) async {
    QuerySnapshot query = await Firestore.instance.collection('datasets')
      .where('owner', isEqualTo: user.uid)
      .where('name', isEqualTo: '_default_')
      .getDocuments();

    if (query.documents.isEmpty) {
      DocumentReference doc = await Firestore.instance.collection('datasets').add({
        'name': '_default_',
        'owner': user.uid,
      });
      return doc;
    }

    return query.documents.first.reference;
  }
}