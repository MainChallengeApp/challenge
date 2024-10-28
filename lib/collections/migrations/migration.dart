import 'package:cloud_firestore/cloud_firestore.dart';

class Migration {
  final int migrationNumber;
  static const migrationNumberField = 'migrationNumber';

  final String description;
  static const descriptionField = 'description';

  final String appVersion;
  static const appVersionField = 'appVersion';

  DateTime createdAt;
  static const createdAtField = 'createdAt';

  final db = FirebaseFirestore.instance;

  Migration(
      {required this.migrationNumber,
      required this.description,
      required this.appVersion,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Future<void> run() async {
    throw UnimplementedError();
  }

  Map<String, dynamic> toDoc() {
    return {
      migrationNumberField: migrationNumber,
      createdAtField: createdAt,
      descriptionField: description,
      appVersionField: appVersion,
    };
  }

  static fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return Migration(
        migrationNumber: doc[migrationNumberField],
        createdAt: (doc[createdAtField] as Timestamp).toDate(),
        description: doc[descriptionField],
        appVersion: doc[appVersionField],
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
