import 'media.dart';

class Evidence {
  int progress;
  List<String> mediaIds;

  Evidence({required this.progress, required this.mediaIds});

  static fromJsonList(json) {
    List<Evidence> list = [];
    json?.forEach((e) => list.add(
        Evidence(progress: e['progress'], mediaIds: List.from(e['mediaIds']))));
    return list;
  }

  static toJsonList(List<Evidence> evidences) {
    return evidences
        .map((e) => {'progress': e.progress, 'mediaIds': e.mediaIds})
        .toList();
  }

  static copyEvidenceList(List<Evidence> evidences) {
    List<Evidence> EvidenceListCopy = [];
    for (var e in EvidenceListCopy) {
      EvidenceListCopy.add(Evidence(
          progress: e.progress, mediaIds: Media.copyMediaIdList(e.mediaIds)));
    }
    return EvidenceListCopy;
  }
}
