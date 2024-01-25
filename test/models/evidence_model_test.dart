import 'package:challenge/models/evidence_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromJsonList()', () {
    test('should create Evidence when json is passed correctly', () {
      // Arrange
      List<Map<String, dynamic>> json = [
        {
          'progress': 1.0,
          'mediaIds': ['1', '2', '3']
        }
      ];
      // Act
      List<EvidenceModel> evidences = EvidenceModel.fromJsonList(json);
      // Assert
      expect(evidences[0].progress, equals(1.0));
      expect(evidences[0].mediaIds, equals(['1', '2', '3']));
    });
  });
}
