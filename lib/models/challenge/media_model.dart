import 'package:challenge/enums/media_type_enum.dart';
import 'package:uuid/uuid.dart';

class MediaModel {
  String? id;
  static const String idField = 'id';

  MediaTypeEnum type;
  static const String typeField = 'type';

  String title;
  static const String titleField = 'title';

  String source;
  static const String sourceField = 'source';

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
        type: MediaTypeEnum.fromString(e[typeField]),
        title: e[titleField],
        source: e[sourceField],
        id: e[idField])));
    return list;
  }

  toDoc() {
    return {
      idField: id,
      typeField: type.text,
      titleField: title,
      sourceField: source
    };
  }

  static copyMediaIdList(List<String> mediaIdList) {
    List<String> mediaIdListCopy = [];
    for (var id in mediaIdList) {
      mediaIdListCopy.add(id);
    }
    return mediaIdListCopy;
  }

  static copyList(List<MediaModel> mediaList) {
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
