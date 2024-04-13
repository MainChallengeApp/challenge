import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/media_model.dart';

class ProgressModel {
  late DateTime date;
  int repetitionNumber;
  double progress;
  double percentProgress;
  List<String> mediaIds;

  ProgressModel(
      {required this.progress,
      required this.mediaIds,
      required this.date,
      required this.percentProgress,
      required this.repetitionNumber});

  ProgressModel.empty(
      {required this.repetitionNumber,
      this.percentProgress = 0,
      this.progress = 0,
      this.mediaIds = const []}) {
    date = DateTime.now();
  }

  setProgress(AcceptanceCriteriaModel acceptanceCriteria, double progress) {
    if (acceptanceCriteria.amount == 0) {
      this.progress = progress;
      percentProgress = 1;
      return;
    }

    this.progress = progress;
    percentProgress = progress / acceptanceCriteria.amount;
  }

  static fromJsonList(json) {
    List<ProgressModel> progressList = [];
    json?.forEach((e) => progressList.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        percentProgress: e['percentProgress'],
        date: DateTime.parse(e['date']),
        repetitionNumber: e['frequencyAmount'])));
    return progressList;
  }

  static toJsonList(List<ProgressModel> progressList) {
    return progressList
        .map((progress) => {
              'date': progress.date.toString(),
              'progress': progress.progress,
              'percentProgress': progress.percentProgress,
              'mediaIds': progress.mediaIds,
              'frequencyAmount': progress.repetitionNumber
            })
        .toList();
  }

  static copyProgressList(List<ProgressModel> progressList) {
    List<ProgressModel> list = [];
    for (var progress in progressList) {
      list.add(copyProgress(progress));
    }
    return list;
  }

  static copyProgress(ProgressModel progress) {
    return ProgressModel(
        date: progress.date,
        progress: progress.progress,
        mediaIds: MediaModel.copyMediaIdList(progress.mediaIds),
        percentProgress: progress.percentProgress,
        repetitionNumber: progress.repetitionNumber);
  }

  static copyOrCreateProgress(
      ProgressModel? progress, int repetitionNumber, List<String> mediaIds) {
    if (progress == null) {
      return ProgressModel.empty(
          repetitionNumber: repetitionNumber, mediaIds: mediaIds);
    }
  }

  static emptyProgress(int frequencyAmount) {
    return ProgressModel(
        progress: 0,
        mediaIds: [],
        date: DateTime.now(),
        percentProgress: 0,
        repetitionNumber: frequencyAmount);
  }
}
