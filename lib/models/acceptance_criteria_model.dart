import 'package:challenge/enums/frequence_type_enum.dart.dart';
import 'package:challenge/models/frequence_model.dart';
import 'package:challenge/models/progress_model.dart';

class AcceptanceCriteriaModel {
  int? id;
  String title;
  double amount;
  String unit;
  FrequenceModel frequence;
  String tracking;
  double currentProgress;
  List<ProgressModel> progress;

  AcceptanceCriteriaModel(
      {required this.id,
      required this.title,
      required this.amount,
      required this.unit,
      required this.frequence,
      required this.tracking,
      required this.currentProgress,
      required this.progress});

  static List<AcceptanceCriteriaModel> fromJsonList(json) {
    List<AcceptanceCriteriaModel> list = [];
    json?.forEach((e) => list.add(AcceptanceCriteriaModel(
        id: e['id'],
        title: e['title'],
        amount: e['amount'],
        unit: e['unit'],
        frequence: FrequenceModel.fromJson(e['frequence']),
        tracking: e['tracking'],
        currentProgress: e['currentProgress'],
        progress: ProgressModel.fromJsonList(e['progress']))));
    return list;
  }

  static toJsonList(List<AcceptanceCriteriaModel> acceptanceCriteria) {
    return acceptanceCriteria
        .map((e) => {
              'id': e.id,
              'title': e.title,
              'amount': e.amount,
              'unit': e.unit,
              'frequence': FrequenceModel.toJson(e.frequence),
              'tracking': e.tracking,
              'currentProgress': e.currentProgress,
              'progress': ProgressModel.toJsonList(e.progress)
            })
        .toList();
  }

  static List<AcceptanceCriteriaModel> copyAcceptanceCriterias(
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
        title: ac.title,
        amount: ac.amount,
        unit: ac.unit,
        frequence: FrequenceModel.copyFrequence(ac.frequence),
        tracking: ac.tracking,
        currentProgress: isTryAgain ? 0 : ac.currentProgress,
        progress:
            isTryAgain ? [] : ProgressModel.copyEvidenceList(ac.progress));
  }

  double calcProgressRatio() {
    if (amount == 0) {
      return 1;
    }
    return currentProgress / amount;
  }

  bool isCompleted() {
    return calcProgressRatio() >= 1;
  }

  int calcCurrentFrequencyAmount(DateTime? challengeStartDate) {
    if (challengeStartDate == null) {
      return 0;
    }
    return frequence.type == FrequenceTypeEnum.daily
        ? DateTime.now().difference(challengeStartDate).inDays + 1
        : 0;
  }

  String calcCurrentDones() {
    int dones = progress
        .where((element) => element.percentProgress >= 1)
        .map((e) => e.date.toString().split(' ')[0])
        .toSet()
        .length;

    return frequence.type == FrequenceTypeEnum.daily
        ? dones == 0
            ? ''
            : '+$dones/'
        : '';
  }

  String calcCurrentFails(DateTime? challengeStartDate) {
    if (challengeStartDate == null) {
      return '';
    }
    DateTime nowWithoutTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int dones = progress
        .where((element) =>
            element.percentProgress >= 1 &&
            !(DateTime(
                    element.date!.year, element.date!.month, element.date!.day)
                .isAtSameMomentAs(nowWithoutTime)))
        .map((e) => e.date.toString().split(' ')[0])
        .toSet()
        .length;

    int fails = DateTime.now().difference(challengeStartDate).inDays - dones;

    return frequence.type == FrequenceTypeEnum.daily
        ? fails == 0
            ? ''
            : '-$fails/'
        : '';
  }
}
