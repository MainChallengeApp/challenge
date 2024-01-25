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
      expect(account.username, equals('email'));
    });
  });

  group('isValidUsername()', () {
    test('should be valide when not empty', () {
      // Arrange
      String username = 'username';
      // Act
      bool isValidUsername = AccountModel.isValidUsername(username);
      // Assert
      expect(isValidUsername, equals(true));
    });

    test('should not be valide when empty', () {
      // Arrange
      String username = '';
      // Act
      bool isValidUsername = AccountModel.isValidUsername(username);
      // Assert
      expect(isValidUsername, equals(false));
    });
  });
}
