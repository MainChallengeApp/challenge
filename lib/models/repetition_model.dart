import 'package:challenge/models/progress_model.dart';

class RepetitionModel {
  final int repetitionNumber;
  final List<ProgressModel> progressList;

  RepetitionModel({required this.repetitionNumber, required this.progressList});

  static toJsonList(List<RepetitionModel> repetitions) {
    return repetitions
        .map((e) => {
              'repetitionNumber': e.repetitionNumber,
              'progressList': ProgressModel.toJsonList(e.progressList)
            })
        .toList();
  }

  static fromJsonList(json) {
    List<RepetitionModel> list = [];
    json?.forEach((e) => list.add(RepetitionModel(
        repetitionNumber: e['repetitionNumber'],
        progressList: ProgressModel.fromJsonList(e['progressList']))));
    return list;
  }
}
