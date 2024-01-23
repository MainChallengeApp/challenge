import 'package:uuid/uuid.dart';

class MediaModel {
  String? id;
  String type;
  String title;
  String source;

  MediaModel(
      {this.id,
      required this.type,
      required this.title,
      required this.source}) {
    if (id == null || id!.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static fromJsonList(json) {
    List<MediaModel> list = [];
    json?.forEach((e) => list.add(MediaModel(
        type: e['type'], title: e['title'], source: e['source'], id: e['id'])));
    return list;
  }

  static toJsonList(List<MediaModel> media) {
    return media
        .map((e) =>
            {'id': e.id, 'type': e.type, 'title': e.title, 'source': e.source})
        .toList();
  }

  static copyMediaIdList(List<String> mediaIdList) {
    List<String> mediaIdListCopy = [];
    for (var id in mediaIdList) {
      mediaIdListCopy.add(id);
    }
    return mediaIdListCopy;
  }

  static copyMediaList(List<MediaModel> mediaList) {
    List<MediaModel> mediaListCopy = [];
    for (var media in mediaList) {
      mediaListCopy.add(MediaModel(
          id: media.id,
          type: media.type,
          title: media.title,
          source: media.source));
    }
    return mediaListCopy;
  }
}
