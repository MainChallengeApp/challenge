import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/report_model.dart';

class ReportsCollection extends Collection {
  static String collectionName = 'reports';

  ReportsCollection() : super(name: collectionName);

  Future<void> create(ReportModel report) async {
    await db.collection(name).add(report.toDoc());
  }
}
