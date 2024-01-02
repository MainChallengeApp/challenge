import 'package:challenge/models/evidence.dart';

import 'activity.dart';

class AcceptanceCriteria {
  int? id;
  Activity activity;
  String frequence;
  String tracking;
  double progress;
  List<Evidence> evidences;

  AcceptanceCriteria(
      {required this.id,
      required this.activity,
      required this.frequence,
      required this.tracking,
      required this.progress,
      required this.evidences});

  static List<AcceptanceCriteria> fromJsonList(json) {
    List<AcceptanceCriteria> list = [];
    json?.forEach((e) => list.add(AcceptanceCriteria(
        id: e['id'],
        activity: Activity.fromJson(e['activity']),
        frequence: e['frequence'],
        tracking: e['tracking'],
        progress: e['progress'],
        evidences: Evidence.fromJsonList(e['evidences']))));
    return list;
  }

  static toJsonList(List<AcceptanceCriteria> acceptanceCriteria) {
    return acceptanceCriteria
        .map((e) => {
              'id': e.id,
              'activity': Activity.toJson(e.activity),
              'frequence': e.frequence,
              'tracking': e.tracking,
              'progress': e.progress,
              'evidences': Evidence.toJsonList(e.evidences)
            })
        .toList();
  }

  static List<AcceptanceCriteria> copyAcceptanceCriteriaList(
      List<AcceptanceCriteria> acceptanceCriteriaList,
      {bool isTryAgain = false}) {
    List<AcceptanceCriteria> acceptanceCriteriaListCopy = [];

    for (var ac in acceptanceCriteriaList) {
      acceptanceCriteriaListCopy
          .add(_copyAcceptanceCriteria(ac, isTryAgain: isTryAgain));
    }

    return acceptanceCriteriaListCopy;
  }

  static AcceptanceCriteria _copyAcceptanceCriteria(AcceptanceCriteria ac,
      {bool isTryAgain = false}) {
    return AcceptanceCriteria(
        id: ac.id,
        activity: Activity.copyActivity(ac.activity),
        frequence: ac.frequence,
        tracking: ac.tracking,
        progress: isTryAgain ? 0 : ac.progress,
        evidences: isTryAgain ? [] : Evidence.copyEvidenceList(ac.evidences));
  }

  double calcProgressRatio() {
    if (activity.amount == 0) {
      return 1;
    }
    return progress / activity.amount;
  }
}
