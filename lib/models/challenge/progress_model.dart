import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  DateTime date;
  static const String dateField = 'date';

  double progress;
  static const String progressField = 'progress';

  List<String> mediaIds;
  static const String mediaIdsField = 'mediaIds';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  ProgressModel({
    required this.progress,
    required this.mediaIds,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? TimeService.now();

  ProgressModel.empty(
      {this.progress = 0, this.mediaIds = const [], DateTime? date})
      : date = date ?? TimeService.now(),
        createdAt = TimeService.now();

  double getGoal(GroupChallengeModel groupChallenge, AttemptModel attempt) {
    return attempt.getAcceptanceCriteria(groupChallenge).amount;
  }

  getProgressPercentage(
      GroupChallengeModel groupChallenge, AttemptModel attempt) {
    double challengeGoal = getGoal(groupChallenge, attempt);
    return challengeGoal == 0 ? 1.0 : progress / challengeGoal;
  }

  updateProgress(ProgressModel newProgress) {
    progress = newProgress.progress;
    mediaIds = newProgress.mediaIds;
  }

  Map<String, dynamic> toDoc() {
    return {
      dateField: Timestamp.fromDate(date),
      progressField: progress,
      mediaIdsField: mediaIds,
      createdAtField: Timestamp.fromDate(createdAt),
    };
  }

  static fromDocs(docs) {
    List<ProgressModel> progressList = [];
    docs.forEach((doc) => progressList.add(ProgressModel(
          progress: doc[progressField],
          mediaIds: List.from(doc[mediaIdsField]),
          date: (doc[dateField] as Timestamp).toDate(),
          createdAt: (doc as Map).containsKey(createdAtField)
              ? (doc[createdAtField] as Timestamp).toDate()
              : null,
        )));
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
      createdAt: createdAt,
    );
  }

  static copyOrCreateProgress(ProgressModel? progress, List<String> mediaIds,
      double progressProgress, DateTime? date) {
    if (progress == null) {
      return ProgressModel.empty(
          mediaIds: mediaIds, progress: progressProgress, date: date);
    }
    return progress.copyProgress();
  }
}
