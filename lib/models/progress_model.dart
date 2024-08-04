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

  updateProgress(ProgressModel newProgress) {
    progress = newProgress.progress;
    percentProgress = newProgress.percentProgress;
    mediaIds = newProgress.mediaIds;
  }

  static fromJsonList(json) {
    List<ProgressModel> progressList = [];
    json?.forEach((e) => progressList.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        percentProgress: e['percentProgress'],
        date: DateTime.parse(e['date']),
        repetitionNumber: e['repetitionNumber'])));
    return progressList;
  }

  static toJsonList(List<ProgressModel> progressList) {
    return progressList
        .map((progress) => {
              'date': progress.date.toString(),
              'progress': progress.progress,
              'percentProgress': progress.percentProgress,
              'mediaIds': progress.mediaIds,
              'repetitionNumber': progress.repetitionNumber
            })
        .toList();
  }

  static copyProgressList(List<ProgressModel> progressList) {
    List<ProgressModel> list = [];
    for (var progress in progressList) {
      list.add(progress.copyProgress());
    }
    return list;
  }

  copyProgress() {
    return ProgressModel(
        date: date,
        progress: progress,
        mediaIds: MediaModel.copyMediaIdList(mediaIds),
        percentProgress: percentProgress,
        repetitionNumber: repetitionNumber);
  }

  static copyOrCreateProgress(ProgressModel? progress, int repetitionNumber,
      List<String> mediaIds, double progressProgress) {
    if (progress == null) {
      return ProgressModel.empty(
          repetitionNumber: repetitionNumber,
          mediaIds: mediaIds,
          progress: progressProgress);
    }
    return progress.copyProgress();
  }
}
