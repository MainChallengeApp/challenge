import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/media_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
      List<MediaModel> media = MediaModel.fromJsonList(json);
      // Assert
      expect(media[0].id, equals('1'));
      expect(media[0].type, equals(MediaTypeEnum.image));
      expect(media[0].title, equals('title'));
      expect(media[0].source, equals('abc/title'));
    });
  });

  group('toJsonList()', () {
    test('should create Media when json is passed correctly', () {
      // Arrange
      List<MediaModel> media = List.from([
        MediaModel(
            id: '1',
            type: MediaTypeEnum.image,
            title: 'title',
            source: 'abc/title')
      ]);
      // Act
      List<Map<String, String?>> json = MediaModel.toJsonList(media);
      // Assert
      expect(
          json,
          equals([
            {
              'id': '1',
              'type': 'image',
              'title': 'title',
              'source': 'abc/title'
            }
          ]));
    });
  });
}
