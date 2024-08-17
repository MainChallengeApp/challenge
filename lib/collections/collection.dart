import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Collection {
  final db = FirebaseFirestore.instance;
  final String name;

  Collection({required this.name});
}
