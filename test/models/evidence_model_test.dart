import 'package:challenge/models/progress_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromJsonList()', () {
    test('should create Evidence when json is passed correctly', () {
      // Arrange
      DateTime date = DateTime.now();
      List<Map<String, dynamic>> json = [
        {
          'progress': 1.0,
          'mediaIds': ['1', '2', '3'],
          'percentProgress': 1.0,
          'date': date,
          'frequencyAmount': 1
        }
      ];
      // Act
      List<ProgressModel> progress = ProgressModel.fromJsonList(json);
      // Assert
      expect(progress[0].progress, equals(1.0));
      expect(progress[0].mediaIds, equals(['1', '2', '3']));
      expect(progress[0].percentProgress, equals(1.0));
      expect(progress[0].date, equals(date));
      expect(progress[0].repetitionNumber, equals(1));
    });
  });
}
