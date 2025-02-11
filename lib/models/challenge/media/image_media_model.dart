import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:uuid/uuid.dart';

class ImageMediaModel extends MediaModel {
  String source;
  static const String sourceField = 'source';

  ImageMediaModel({String? id, required String title, required this.source})
      : super(id: id, title: title, type: MediaTypeEnum.image) {
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static fromDoc(doc) {
    return ImageMediaModel(
        id: doc[MediaModel.idField],
        title: doc[MediaModel.titleField],
        source: doc[sourceField]);
  }

  @override
  toDoc() {
    return {...super.toDoc(), sourceField: source};
  }

  static copyMediaIdList(List<String> mediaIdList) {
    List<String> mediaIdListCopy = [];
    for (var id in mediaIdList) {
      mediaIdListCopy.add(id);
    }
    return mediaIdListCopy;
  }

  static copyList(List<ImageMediaModel> mediaList) {
    List<ImageMediaModel> mediaListCopy = [];
    for (var media in mediaList) {
      mediaListCopy.add(ImageMediaModel(
          id: media.id, title: media.title, source: media.source));
    }
    return mediaListCopy;
  }

  @override
  copy() {
    return ImageMediaModel(id: id, title: title, source: source);
  }
}
