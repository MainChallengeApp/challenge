import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/utils/design_util.dart';

class AcceptanceCriteriaModel {
  double amount;
  String unit;
  FrequencyModel frequency;
  String tracking;
  double currentProgress;
  List<RepetitionModel> repetitions;

  AcceptanceCriteriaModel(
      {required this.amount,
      required this.unit,
      required this.frequency,
      required this.tracking,
      required this.currentProgress,
      required this.repetitions}) {
    if (repetitions.length != (frequency.amount ?? 0)) {
      repetitions = [];
      for (var i = 1; i <= (frequency.amount ?? 0); i++) {
        repetitions.add(RepetitionModel(repetitionNumber: i, progressList: []));
      }
    }
  }

  static AcceptanceCriteriaModel fromJson(json) {
    return AcceptanceCriteriaModel(
        amount: json['amount'],
        unit: json['unit'],
        frequency: FrequencyModel.fromJson(json['frequency']),
        tracking: json['tracking'],
        currentProgress: json['currentProgress'],
        repetitions: RepetitionModel.fromJsonList(json['repetitions']));
  }

  static toJson(AcceptanceCriteriaModel acceptanceCriteria) {
    return {
      'amount': acceptanceCriteria.amount,
      'unit': acceptanceCriteria.unit,
      'frequency': FrequencyModel.toJson(acceptanceCriteria.frequency),
      'tracking': acceptanceCriteria.tracking,
      'currentProgress': acceptanceCriteria.currentProgress,
      'repetitions': RepetitionModel.toJsonList(acceptanceCriteria.repetitions)
    };
  }

  static emptyAcceptanceCriteria() {
    return AcceptanceCriteriaModel(
        amount: 0,
        unit: '',
        frequency: FrequencyModel(
            amount: 1, type: FrequencyTypeEnum.time, currentAmount: 0),
        tracking: 'camera',
        currentProgress: 0,
        repetitions: []);
  }

  static AcceptanceCriteriaModel copyAcceptanceCriteria(
      AcceptanceCriteriaModel ac,
      {bool isTryAgain = false}) {
    return AcceptanceCriteriaModel(
        amount: ac.amount,
        unit: ac.unit,
        frequency: FrequencyModel.copyFrequency(ac.frequency),
        tracking: ac.tracking,
        currentProgress: isTryAgain ? 0 : ac.currentProgress,
        repetitions: isTryAgain
            ? null
            : ProgressModel.copyRepetitionList(ac.repetitions));
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

  int getCurrentFrequencyAmount(DateTime? challengeStartDate) {
    if (frequency.type == FrequencyTypeEnum.daily) {
      if (challengeStartDate == null ||
          DesignUtil.dateWithoutTime(DateTime.now())
              .isBefore(challengeStartDate)) {
        return 0;
      }
      return frequency.type == FrequencyTypeEnum.daily
          ? DateTime.now().difference(challengeStartDate).inDays + 1
          : 0;
    } else if (frequency.type == FrequencyTypeEnum.time) {
      return frequency.currentAmount ?? 0;
    } else {
      return 0;
    }
  }

  int calcCurrentDones() {
    int dones = repetitions.where((repetition) {
      if (repetition.progressList.isEmpty) {
        return false;
      }
      repetition.progressList.sort((a, b) =>
          b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
      return repetition.progressList.first.percentProgress >= 1;
    }).length;
    return dones;
  }

  // String calcCurrentFails(DateTime? challengeStartDate) {
  //   if (challengeStartDate == null ||
  //       challengeStartDate
  //           .isAfter(DesignUtil.dateWithoutTime(DateTime.now()))) {
  //     return '';
  //   }
  //   DateTime nowWithoutTime =
  //       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //   int dones = progress
  //       .where((element) =>
  //           element.percentProgress >= 1 &&
  //           !(DateTime(
  //                   element.date!.year, element.date!.month, element.date!.day)
  //               .isAtSameMomentAs(nowWithoutTime)))
  //       .map((e) => e.date.toString().split(' ')[0])
  //       .toSet()
  //       .length;

  //   int fails = DateTime.now().difference(challengeStartDate).inDays - dones;

  //   return frequency.type == FrequencyTypeEnum.daily
  //       ? fails == 0
  //           ? ''
  //           : '-$fails'
  //       : '';
  // }
}
