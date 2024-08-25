import 'package:challenge/models/challenge/media_model.dart';

class ProgressModel {
  late DateTime date;
  static const String dateField = 'date';

  int repetitionNumber;
  static const String repetitionNumberField = 'repetitionNumber';

  double progress;
  static const String progressField = 'progress';

  double goal;
  static const String goalField = 'goal';

  List<String> mediaIds;
  static const String mediaIdsField = 'mediaIds';

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

  Map<String, dynamic> toDoc() {
    return {
      dateField: date.toString(),
      progressField: progress,
      mediaIdsField: mediaIds,
      repetitionNumberField: repetitionNumber,
      goalField: goal
    };
  }

  static fromDocs(docs) {
    List<ProgressModel> progressList = [];
    docs.forEach((doc) => progressList.add(ProgressModel(
        progress: doc[progressField],
        mediaIds: List.from(doc[mediaIdsField]),
        date: DateTime.parse(doc[dateField]),
        repetitionNumber: doc[repetitionNumberField],
        goal: doc[goalField])));
    return progressList;
  }

  static List<Map<String, dynamic>> toDocs(List<ProgressModel> progressList) {
    return progressList.map((progress) => progress.toDoc()).toList();
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
