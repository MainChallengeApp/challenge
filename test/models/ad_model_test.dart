import 'package:challenge/models/challenge/ad_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

AdModel mockAdModel() {
  return AdModel(text: FakerService.word(), url: FakerService.url());
}

void main() {
  group('AdModel', () {
    test('should create AdModel with required parameters', () {
      // Arrange
      const text = 'Test Ad Text';
      const url = 'https://example.com';

      // Act
      final adModel = AdModel(text: text, url: url);

      // Assert
      expect(adModel.text, equals(text));
      expect(adModel.url, equals(url));
    });

    test('should create AdModel from valid JSON', () {
      // Arrange
      String text = FakerService.word();
      String url = FakerService.url();
      final json = {
        AdModel.textField: text,
        AdModel.urlField: url,
      };

      // Act
      final adModel = AdModel.fromDoc(json);

      // Assert
      expect(adModel.text, equals(text));
      expect(adModel.url, equals(url));
    });

    test('should throw FormatException when creating from invalid JSON', () {
      // Arrange
      final invalidJson = {
        'invalidField': 'value',
      };

      // Act & Assert
      expect(
        () => AdModel.fromDoc(invalidJson),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException when JSON has null values', () {
      // Arrange
      final jsonWithNull = {
        AdModel.textField: null,
        AdModel.urlField: FakerService.url(),
      };

      // Act & Assert
      expect(
        () => AdModel.fromDoc(jsonWithNull),
        throwsA(isA<FormatException>()),
      );
    });

    test('should convert AdModel to document map', () {
      // Arrange
      String text = FakerService.word();
      String url = FakerService.url();
      final adModel = AdModel(text: text, url: url);

      // Act
      final doc = adModel.toDoc();

      // Assert
      expect(
          doc,
          equals({
            AdModel.textField: text,
            AdModel.urlField: url,
          }));
    });

    test('should create copy of AdModel', () {
      // Arrange
      String text = FakerService.word();
      String url = FakerService.url();
      final originalAdModel = AdModel(text: text, url: url);

      // Act
      final copiedAdModel = originalAdModel.copy();

      // Assert
      expect(copiedAdModel.text, equals(originalAdModel.text));
      expect(copiedAdModel.url, equals(originalAdModel.url));
      expect(copiedAdModel, isNot(same(originalAdModel)));
    });

    test('should handle empty strings', () {
      // Arrange
      const emptyText = '';
      const emptyUrl = '';

      // Act
      final adModel = AdModel(text: emptyText, url: emptyUrl);

      // Assert
      expect(adModel.text, equals(emptyText));
      expect(adModel.url, equals(emptyUrl));
    });

    test('should work with mock data from FakerService', () {
      // Act
      final adModel = mockAdModel();

      // Assert
      expect(adModel.text, isA<String>());
      expect(adModel.url, isA<String>());
      expect(adModel.text.isNotEmpty, isTrue);
      expect(adModel.url.isNotEmpty, isTrue);
    });
  });
}
