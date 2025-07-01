import 'package:cloud_firestore/cloud_firestore.dart';

class StopwatchRoundEntryModel {
  DateTime startTime;
  static const String startTimeField = 'startTime';

  DateTime? stopTime;
  static const String stopTimeField = 'stopTime';

  StopwatchRoundEntryModel({required this.startTime, this.stopTime});

  Duration get duration => (stopTime ?? DateTime.now()).difference(startTime);

  static fromDoc(doc) {
    return StopwatchRoundEntryModel(
        startTime: (doc[startTimeField] as Timestamp).toDate(),
        stopTime: doc[stopTimeField] == null
            ? null
            : (doc[stopTimeField] as Timestamp).toDate());
  }

  toDoc() {
    return {
      startTimeField: startTime,
      stopTimeField: stopTime,
    };
  }
}
