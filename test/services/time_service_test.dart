import 'package:challenge/services/time_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeService', () {
    group('now', () {
      test('should return the current time', () async {
        // Arrange
        final currentTime = DateTime.now();
        // Act
        final result = await TimeService.now();
        // Assert
        expect(result.isAfter(currentTime), true);
      });
    });
  });
}
