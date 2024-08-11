import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {
  final db = FirebaseFirestore.instance;
  late final String collection;
}
