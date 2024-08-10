import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/exceptions/media_type_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });

  group('fromJsonList()', () {
    test('should create Media when json is passed correctly', () {
      // Arrange
      List<Map<String, dynamic>> json = [
        {
          'id': '1',
          'type': 'image',
          'title': 'title',
          'source': 'abc/title',
        }
      ];
      // Act
      List<MediaModel> media = MediaModel.fromDocs(json);
      // Assert
      expect(media[0].id, equals('1'));
      expect(media[0].type, equals(MediaTypeEnum.image));
      expect(media[0].title, equals('title'));
      expect(media[0].source, equals('abc/title'));
    });

    test('should throw media type is not supported exception', () {
      // Arrange
      List<Map<String, dynamic>> json = [
        {
          'id': '1',
          'type': 'not supported media type',
          'title': 'title',
          'source': 'abc/title',
        }
      ];
      // Act
      // Assert
      expect(() => MediaModel.fromDocs(json),
          throwsA(isA<MediaTypeIsNotSupportedException>()));
    });
  });

  group('toJson()', () {
    test('should create Media when json is passed correctly', () {
      // Arrange
      MediaModel media = MediaModel(
          id: '1',
          type: MediaTypeEnum.image,
          title: 'title',
          source: 'abc/title');
      // Act
      Map<String, String?> json = media.toDoc();
      // Assert
      expect(
          json,
          equals({
            'id': '1',
            'type': 'image',
            'title': 'title',
            'source': 'abc/title'
          }));
    });
  });

  group('copyMediaIdList()', () {
    test('should copy string array', () {
      // Arrange
      List<String> mediaIdList = ['1', '2'];
      // Act
      List<String> mediaIdListCopy = MediaModel.copyMediaIdList(mediaIdList);
      // Assert
      expect(mediaIdListCopy, equals(mediaIdList));
    });
  });

  group('copyMediaList()', () {
    test('should copy media list', () {
      // Arrange
      List<MediaModel> mediaList = List.from([
        MediaModel(
            id: '1',
            type: MediaTypeEnum.image,
            title: 'title',
            source: 'abc/title')
      ]);
      // Act
      List<MediaModel> mediaListCopy = MediaModel.copyMediaList(mediaList);
      // Assert
      expect(mediaListCopy[0].id, equals('1'));
      expect(mediaListCopy[0].type, equals(MediaTypeEnum.image));
      expect(mediaListCopy[0].title, equals('title'));
      expect(mediaListCopy[0].source, equals('abc/title'));
    });
  });
}
