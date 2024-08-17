import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CollectionSeedModel {
  final String collectionName;
  final db = FirebaseFirestore.instance;

  CollectionSeedModel({required this.collectionName});

  Future<void> run();

  List<Map<String, dynamic>> createData();

  Future<void> clearCollection() async {
    QuerySnapshot snapshot = await db.collection(collectionName).get();
    for (var doc in snapshot.docs) {
      await db.collection(collectionName).doc(doc.id).delete();
    }
  }
}
