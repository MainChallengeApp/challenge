import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String id;
  static const String idField = 'id';

  String userId;
  static const String userIdField = 'userId';

  String reportedUserId;
  static const String reportedUserIdField = 'reportedUserId';

  String reason;
  static const String reasonField = 'reason';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  ReportModel(
      {required this.userId,
      required this.reportedUserId,
      required this.reason,
      DateTime? createdAt,
      String? id})
      : createdAt = createdAt ?? DateTime.now(),
        id = id ?? '';

  Map<String, dynamic> toDoc() {
    return {
      userIdField: userId,
      reportedUserIdField: reportedUserId,
      reasonField: reason,
      createdAtField: createdAt,
    };
  }

  factory ReportModel.fromDoc(DocumentSnapshot doc) {
    return ReportModel(
      id: doc.id,
      userId: doc[userIdField],
      reportedUserId: doc[reportedUserIdField],
      reason: doc[reasonField],
      createdAt: doc[createdAtField],
    );
  }
}
