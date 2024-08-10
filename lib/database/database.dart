import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Database {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late final String collection;
}
