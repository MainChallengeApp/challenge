import 'package:challenge/models/evidence.model.dart';

import 'activity.model.dart';

class AcceptanceCriteriaModel {
  int? id;
  ActivityModel activity;
  String frequence;
  String tracking;
  double progress;
  List<EvidenceModel> evidences;

  AcceptanceCriteriaModel(
      {required this.id,
      required this.activity,
      required this.frequence,
      required this.tracking,
      required this.progress,
      required this.evidences});

  static List<AcceptanceCriteriaModel> fromJsonList(json) {
    List<AcceptanceCriteriaModel> list = [];
    json?.forEach((e) => list.add(AcceptanceCriteriaModel(
        id: e['id'],
        activity: ActivityModel.fromJson(e['activity']),
        frequence: e['frequence'],
        tracking: e['tracking'],
        progress: e['progress'],
        evidences: EvidenceModel.fromJsonList(e['evidences']))));
    return list;
  }

  static toJsonList(List<AcceptanceCriteriaModel> acceptanceCriteria) {
    return acceptanceCriteria
        .map((e) => {
              'id': e.id,
              'activity': ActivityModel.toJson(e.activity),
              'frequence': e.frequence,
              'tracking': e.tracking,
              'progress': e.progress,
              'evidences': EvidenceModel.toJsonList(e.evidences)
            })
        .toList();
  }

  static List<AcceptanceCriteriaModel> copyAcceptanceCriteriaList(
      List<AcceptanceCriteriaModel> acceptanceCriteriaList,
      {bool isTryAgain = false}) {
    List<AcceptanceCriteriaModel> acceptanceCriteriaListCopy = [];

    for (var ac in acceptanceCriteriaList) {
      acceptanceCriteriaListCopy
          .add(_copyAcceptanceCriteria(ac, isTryAgain: isTryAgain));
    }

    return acceptanceCriteriaListCopy;
  }

  static AcceptanceCriteriaModel _copyAcceptanceCriteria(
      AcceptanceCriteriaModel ac,
      {bool isTryAgain = false}) {
    return AcceptanceCriteriaModel(
        id: ac.id,
        activity: ActivityModel.copyActivity(ac.activity),
        frequence: ac.frequence,
        tracking: ac.tracking,
        progress: isTryAgain ? 0 : ac.progress,
        evidences:
            isTryAgain ? [] : EvidenceModel.copyEvidenceList(ac.evidences));
  }

  double calcProgressRatio() {
    if (activity.amount == 0) {
      return 1;
    }
    return progress / activity.amount;
  }

  bool isCompleted() {
    return calcProgressRatio() >= 1;
  }

  static bool areAllAcceptanceCriteriasCompleted(
      {required List<AcceptanceCriteriaModel> acceptanceCriterias}) {
    for (var ac in acceptanceCriterias) {
      if (!ac.isCompleted()) {
        return false;
      }
    }
    return true;
  }
}
