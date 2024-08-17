import 'package:challenge/services/design_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('doubleAsInt()', () {
    test('should represent double as int when ends with .0', () {
      // Arrange
      double number = 1.0;
      // Act
      String result = DesignService.doubleAsIntString(number);
      // Assert
      expect(result, equals('1'));
    });

    test('should represent double as double when ends not with .0', () {
      // Arrange
      double number = 1.1;
      // Act
      String result = DesignService.doubleAsIntString(number);
      // Assert
      expect(result, equals('1.1'));
    });
  });
}
