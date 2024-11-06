import 'package:challenge/collections/reports_collection.dart';
import 'package:challenge/models/report_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:flutter/material.dart';

class ReportsProvider with ChangeNotifier {
  ReportsCollection reportsCollection = ReportsCollection();
  AuthService authService = AuthService();

  Future<void> createReport(String userId, String reason) async {
    final report = ReportModel(
      userId: authService.getCurrentUserId(),
      reportedUserId: userId,
      reason: reason,
      createdAt: await TimeService.now(),
    );
    await reportsCollection.create(report);
  }
}
