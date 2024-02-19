import 'media_model.dart';

class ProgressModel {
  double progress;
  List<String> mediaIds;

  ProgressModel({required this.progress, required this.mediaIds});

  static fromJsonList(json) {
    List<ProgressModel> list = [];
    json?.forEach((e) => list.add(ProgressModel(
        progress: e['progress'], mediaIds: List.from(e['mediaIds']))));
    return list;
  }

  static toJsonList(List<ProgressModel> progress) {
    return progress
        .map((p) => {'progress': p.progress, 'mediaIds': p.mediaIds})
        .toList();
  }

  static copyEvidenceList(List<ProgressModel> progress) {
    List<ProgressModel> progressListCopy = [];
    for (var e in progressListCopy) {
      progressListCopy.add(ProgressModel(
          progress: e.progress,
          mediaIds: MediaModel.copyMediaIdList(e.mediaIds)));
    }
    return progressListCopy;
  }
}
