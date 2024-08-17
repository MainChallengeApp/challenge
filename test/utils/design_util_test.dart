import 'package:challenge/services/design_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DesignUtil', () {
    group('doubleAsIntString()', () {
      test('should represent doubles without .0', () {
        expect(DesignService.doubleAsIntString(1.0), '1');
        expect(DesignService.doubleAsIntString(1.1), '1.1');
      });
    });

    group('dateWithoutTime()', () {
      test('should return date without time', () {
        DateTime date = DateTime(2021, 1, 1, 12, 30);
        expect(DesignService.dateWithoutTime(date), DateTime(2021, 1, 1));
      });
    });
  });
}
