import 'package:challenge/models/challenge/account_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromJson()', () {
    test('should create Account when json is passed correctly', () {
      // Arrange
      Map<String, dynamic> json = {'email': 'email'};
      // Act
      AccountModel account = AccountModel.fromDoc(json);
      // Assert
      expect(account.username, equals('email'));
    });
  });

  group('toJson()', () {
    test('should return json when Account is passed correctly', () {
      // Arrange
      AccountModel account = AccountModel(username: 'email');
      // Act
      Map<String, dynamic> json = account.toDoc();
      // Assert
      expect(json['email'], equals(account.username));
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
