import 'package:challenge/models/account_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromJson()', () {
    test('should create Account when json is passed correctly', () {
      // Arrange
      Map<String, dynamic> json = {'email': 'email'};
      // Act
      AccountModel account = AccountModel.fromJson(json);
      // Assert
      expect(account.email, equals('email'));
    });
  });
}
