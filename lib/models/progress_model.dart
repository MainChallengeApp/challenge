import 'media_model.dart';

class ProgressModel {
  DateTime? date;
  double progress;
  double percentProgress;
  List<String> mediaIds;

  ProgressModel(
      {required this.progress,
      required this.mediaIds,
      this.date,
      required this.percentProgress}) {
    date ??= DateTime.now();
  }

  static fromJsonList(json) {
    List<ProgressModel> list = [];
    json?.forEach((e) => list.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        percentProgress: e['percentProgress'])));
    return list;
  }

  static toJsonList(List<ProgressModel> progress) {
    return progress
        .map((p) => {
              'date': p.date.toString(),
              'progress': p.progress,
              'mediaIds': p.mediaIds
            })
        .toList();
  }

  static copyEvidenceList(List<ProgressModel> progress) {
    List<ProgressModel> progressListCopy = [];
    for (var e in progressListCopy) {
      progressListCopy.add(ProgressModel(
          date: e.date,
          progress: e.progress,
          mediaIds: MediaModel.copyMediaIdList(e.mediaIds),
          percentProgress: e.percentProgress));
    }
    return progressListCopy;
  }
}
