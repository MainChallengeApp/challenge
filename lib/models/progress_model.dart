import 'package:challenge/models/media_model.dart';

class ProgressModel {
  late DateTime date;
  int repetitionNumber;
  double progress;
  double goal;
  List<String> mediaIds;

  ProgressModel(
      {required this.progress,
      required this.mediaIds,
      required this.date,
      required this.repetitionNumber,
      required this.goal});

  ProgressModel.empty(
      {required this.repetitionNumber,
      required this.goal,
      this.progress = 0,
      this.mediaIds = const []}) {
    date = DateTime.now();
  }

  getPercentProgress() {
    return goal == 0 ? 1.0 : progress / goal;
  }

  updateProgress(ProgressModel newProgress) {
    progress = newProgress.progress;
    mediaIds = newProgress.mediaIds;
    goal = newProgress.goal;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toString(),
      'progress': progress,
      'mediaIds': mediaIds,
      'repetitionNumber': repetitionNumber,
      'goal': goal
    };
  }

  static fromJsonList(json) {
    List<ProgressModel> progressList = [];
    json?.forEach((e) => progressList.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        date: DateTime.parse(e['date']),
        repetitionNumber: e['repetitionNumber'],
        goal: e['goal'])));
    return progressList;
  }

  static List<Map<String, dynamic>> toJsonList(
      List<ProgressModel> progressList) {
    return progressList.map((progress) => progress.toJson()).toList();
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
        repetitionNumber: repetitionNumber,
        goal: goal);
  }

  static copyOrCreateProgress(ProgressModel? progress, int repetitionNumber,
      double goal, List<String> mediaIds, double progressProgress) {
    if (progress == null) {
      return ProgressModel.empty(
          repetitionNumber: repetitionNumber,
          goal: goal,
          mediaIds: mediaIds,
          progress: progressProgress);
    }
    return progress.copyProgress();
  }
}
