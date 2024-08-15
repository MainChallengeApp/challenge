import 'package:cloud_firestore/cloud_firestore.dart';

class MigrationModel {
  final int migrationNumber;
  final String description;
  DateTime createdAt;
  final db = FirebaseFirestore.instance;

  MigrationModel(
      {required this.migrationNumber,
      required this.description,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Future<void> run() async {
    throw UnimplementedError();
  }

  Map<String, dynamic> toDoc() {
    return {
      'migrationNumber': migrationNumber,
      'createdAt': createdAt,
      'description': description,
    };
  }

  static fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return MigrationModel(
        migrationNumber: doc['migrationNumber'],
        createdAt: (doc['createdAt'] as Timestamp).toDate(),
        description: doc['description'],
      );
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateMany(String collection, Map<String, dynamic> docs) async {
    final batch = db.batch();
    docs.forEach((key, value) {
      final ref = db.collection(collection).doc(key);
      batch.set(ref, value);
    });
    await batch.commit();
  }
}
