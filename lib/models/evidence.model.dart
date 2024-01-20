import 'media.model.dart';

class EvidenceModel {
  double progress;
  List<String> mediaIds;

  EvidenceModel({required this.progress, required this.mediaIds});

  static fromJsonList(json) {
    List<EvidenceModel> list = [];
    json?.forEach((e) => list.add(EvidenceModel(
        progress: e['progress'], mediaIds: List.from(e['mediaIds']))));
    return list;
  }

  static toJsonList(List<EvidenceModel> evidences) {
    return evidences
        .map((e) => {'progress': e.progress, 'mediaIds': e.mediaIds})
        .toList();
  }

  static copyEvidenceList(List<EvidenceModel> evidences) {
    List<EvidenceModel> EvidenceListCopy = [];
    for (var e in EvidenceListCopy) {
      EvidenceListCopy.add(EvidenceModel(
          progress: e.progress,
          mediaIds: MediaModel.copyMediaIdList(e.mediaIds)));
    }
    return EvidenceListCopy;
  }
}
