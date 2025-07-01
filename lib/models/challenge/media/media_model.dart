import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/exceptions/media_type_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/media/image_media_model.dart';
import 'package:challenge/models/challenge/media/note_media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_media_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class MediaModel {
  String? id;
  static const String idField = 'id';

  String title;
  static const String titleField = 'title';

  MediaTypeEnum type;
  static const String typeField = 'type';

  IconData icon;

  MediaModel({
    this.id,
    required this.title,
    required this.type,
    required this.icon,
  }) {
    if (id == null || id!.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static fromDocs(docs) {
    List<MediaModel> list = [];
    docs?.forEach((media) {
      if (media.containsKey(typeField) == false) {
        throw const MediaTypeIsNotSupportedException('null');
      }
      if (media[typeField] == MediaTypeEnum.image.text) {
        list.add(ImageMediaModel.fromDoc(media));
      } else if (media[typeField] == MediaTypeEnum.note.text) {
        list.add(NoteMediaModel.fromDoc(media));
      } else if (media[typeField] == MediaTypeEnum.stopwatch.text) {
        list.add(StopwatchMediaModel.fromDoc(media));
      } else {
        throw MediaTypeIsNotSupportedException(media[typeField]);
      }
    });
    return list;
  }

  toDoc() {
    return {
      idField: id,
      typeField: type.text,
      titleField: title,
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
      mediaListCopy.add(media.copy());
    }
    return mediaListCopy;
  }

  copy();
}
