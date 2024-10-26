class ReportModel {
  String id;
  static const String idField = 'id';

  String reportedByUserId;
  static const String reportedByUserIdField = 'reportedByUserId';

  String reportedUserId;
  static const String reportedUserIdField = 'reportedUserId';

  String reason;
  static const String reasonField = 'reason';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  ReportModel(
      {required this.reportedByUserId,
      required this.reportedUserId,
      required this.reason,
      DateTime? createdAt,
      String? id})
      : createdAt = createdAt ?? DateTime.now(),
        id = id ?? '';

  Map<String, dynamic> toDoc() {
    return {
      reportedByUserIdField: reportedByUserId,
      reportedUserIdField: reportedUserId,
      reasonField: reason,
      createdAtField: createdAt,
    };
  }

  factory ReportModel.fromDoc(Map<String, dynamic> doc) {
    return ReportModel(
      id: doc['id'],
      reportedByUserId: doc['reportedByUserId'],
      reportedUserId: doc['reportedUserId'],
      reason: doc['reason'],
      createdAt: doc['createdAt'],
    );
  }
}
