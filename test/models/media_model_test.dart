import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/exceptions/media_type_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

MediaModel mockMediaModel({
  String? id,
  MediaTypeEnum? type,
  String? title,
  String? source,
}) {
  return MediaModel(
      id: id ?? FakerService.guid(),
      type: type ?? FakerService.randomObject(MediaTypeEnum.values),
      title: title ?? FakerService.word(),
      source: source ?? FakerService.url());
}

void main() {
  group('MediaModel()', () {
    test('should create Media when id is null', () {
      // Arrange
      MediaModel media = MediaModel(
          id: null,
          type: MediaTypeEnum.image,
          title: 'title',
          source: 'abc/title');
      // Act
      // Assert
      expect(media.id, isNotNull);
      expect(media.type, equals(MediaTypeEnum.image));
      expect(media.title, equals('title'));
      expect(media.source, equals('abc/title'));
    });

    test('should create Media when id is not null', () {
      // Arrange
      MediaModel media = MediaModel(
          id: '1',
          type: MediaTypeEnum.image,
          title: 'title',
          source: 'abc/title');
      // Act
      // Assert
      expect(media.id, equals('1'));
      expect(media.type, equals(MediaTypeEnum.image));
      expect(media.title, equals('title'));
      expect(media.source, equals('abc/title'));
    });
    group('fromDocs())', () {
      test('should create Media when doc is passed correctly', () {
        // Arrange

        String id = FakerService.guid();
        MediaTypeEnum type = FakerService.randomObject(MediaTypeEnum.values);
        String title = FakerService.word();
        String source = FakerService.url();

        List<Map<String, dynamic>> json = [
          {
            'id': id,
            'type': type.text,
            'title': title,
            'source': source,
          }
        ];
        // Act
        List<MediaModel> media = MediaModel.fromDocs(json);
        // Assert
        expect(media[0].id, equals(id));
        expect(media[0].type, equals(type));
        expect(media[0].title, equals(title));
        expect(media[0].source, equals(source));
      });

      test('should throw media type is not supported exception', () {
        // Arrange
        List<Map<String, dynamic>> doc = [
          {
            'id': '1',
            'type': 'not supported media type',
            'title': 'title',
            'source': 'abc/title',
          }
        ];
        // Act
        // Assert
        expect(() => MediaModel.fromDocs(doc),
            throwsA(isA<MediaTypeIsNotSupportedException>()));
      });
    });

    group('toDoc()', () {
      test('should create Media Model as doc', () {
        // Arrange
        MediaModel media = mockMediaModel();
        // Act
        Map<String, String?> json = media.toDoc();
        // Assert
        expect(
            json,
            equals({
              'id': media.id,
              'type': media.type.text,
              'title': media.title,
              'source': media.source
            }));
      });
    });

    group('copyMediaIdList()', () {
      test('should copy string array', () {
        // Arrange
        List<String> mediaIdList =
            FakerService.list((_) => FakerService.guid());
        // Act
        List<String> mediaIdListCopy = MediaModel.copyMediaIdList(mediaIdList);
        // Assert
        expect(mediaIdListCopy, equals(mediaIdList));
      });
    });

    group('copyMediaList()', () {
      test('should copy media list', () {
        // Arrange
        List<MediaModel> mediaList = FakerService.list((_) => mockMediaModel());

        // Act
        List<MediaModel> mediaListCopy = MediaModel.copyList(mediaList);

        // Assert

        // Check that the contents are the same
        for (int i = 0; i < mediaList.length; i++) {
          expect(mediaList[i].id, equals(mediaListCopy[i].id));
          expect(mediaList[i].source, equals(mediaListCopy[i].source));
          expect(mediaList[i].title, equals(mediaListCopy[i].title));
          expect(mediaList[i].type, equals(mediaListCopy[i].type));
        }
        // Check that they are not the same object
        expect(identical(mediaList, mediaListCopy), isFalse);
      });
    });
  });
}
