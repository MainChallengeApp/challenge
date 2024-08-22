import 'package:challenge/enums/media_type_enum.dart';
import 'package:uuid/uuid.dart';

class MediaModel {
  String? id;
  MediaTypeEnum type;
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

  static fromDocs(docs) {
    List<MediaModel> list = [];
    docs?.forEach((e) => list.add(MediaModel(
        type: MediaTypeEnum.fromString(e['type']),
        title: e['title'],
        source: e['source'],
        id: e['id'])));
    return list;
  }

  toDoc() {
    return {'id': id, 'type': type.type, 'title': title, 'source': source};
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

  bool isLocal() {
    return !source.startsWith('https://');
  }

  bool isImage() {
    return type == MediaTypeEnum.image;
  }
}
