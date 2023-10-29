import 'package:challenge/models/evidence.dart';

import 'activity.dart';

class AcceptanceCriteria {
  int? id;
  Activity activity;
  String frequence;
  String tracking;
  int progress;
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

  static copyAcceptanceCriteriaList(
      List<AcceptanceCriteria> acceptanceCriteriaList) {
    List<AcceptanceCriteria> acceptanceCriteriaListCopy = [];
    for (var a in acceptanceCriteriaList) {
      acceptanceCriteriaListCopy.add(AcceptanceCriteria(
          id: a.id,
          activity: Activity.copyActivity(a.activity),
          frequence: a.frequence,
          tracking: a.tracking,
          progress: a.progress,
          evidences: Evidence.copyEvidenceList(a.evidences)));
    }
    return acceptanceCriteriaListCopy;
  }
}
