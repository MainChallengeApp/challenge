import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:uuid/uuid.dart';

class NoteMediaModel extends MediaModel {
  String content;
  static const String contentField = 'content';

  NoteMediaModel({String? id, required String title, this.content = ''})
      : super(
            id: id,
            title: title,
            type: MediaTypeEnum.note,
            icon: IconEnum.notes.icon) {
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static fromDoc(doc) {
    return NoteMediaModel(
        id: doc[MediaModel.idField],
        title: doc[MediaModel.titleField],
        content: doc[contentField]);
  }

  @override
  toDoc() {
    return {...super.toDoc(), contentField: content};
  }

  @override
  copy() {
    return NoteMediaModel(id: id, title: title, content: content);
  }
}
