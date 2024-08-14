import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AcceptanceCriteriaModel', () {
    group('empty()', () {
      test('should return an empty acceptance criteria', () {
        // Arrange
        AcceptanceCriteriaModel acceptanceCriteria =
            AcceptanceCriteriaModel(amount: 1.0, unit: '');

        // Act
        AcceptanceCriteriaModel emptyAcceptanceCriteria =
            AcceptanceCriteriaModel.empty();

        // Assert
        expect(
            emptyAcceptanceCriteria.amount, equals(acceptanceCriteria.amount));
        expect(emptyAcceptanceCriteria.unit, equals(acceptanceCriteria.unit));
      });
    });

    group('fromJson()', () {
      test('should return an acceptance criteria from a json', () {
        // Arrange
        Map<String, dynamic> json = {'amount': 2.0, 'unit': 'unit'};
        AcceptanceCriteriaModel acceptanceCriteria =
            AcceptanceCriteriaModel(amount: 2.0, unit: 'unit');

        // Act
        AcceptanceCriteriaModel acceptanceCriteriaFromJson =
            AcceptanceCriteriaModel.fromDoc(json);

        // Assert
        expect(acceptanceCriteriaFromJson.amount,
            equals(acceptanceCriteria.amount));
        expect(
            acceptanceCriteriaFromJson.unit, equals(acceptanceCriteria.unit));
      });

      test('should throw error when passing an invalid json', () {
        // Arrange
        Map<String, dynamic> json = {'amount': '2', 'unit': 'unit'};

        // Assert & // Act
        expect(() => AcceptanceCriteriaModel.fromDoc(json),
            throwsA(isA<TypeError>()));
      });
    });

    group('toJson()', () {
      test('should return a json from an acceptance criteria', () {
        // Arrange
        AcceptanceCriteriaModel acceptanceCriteria =
            AcceptanceCriteriaModel(amount: 2.0, unit: 'unit');
        Map<String, dynamic> expectedJson = {'amount': 2.0, 'unit': 'unit'};

        // Act
        Map<String, dynamic> acceptanceCriteriaToJson =
            acceptanceCriteria.toDoc();

        // Assert
        expect(acceptanceCriteriaToJson, equals(expectedJson));
      });
    });

    group('copyAcceptanceCriteriaList()', () {
      test(
          'should copy acceptance criteria list when passing an acceptance criteria',
          () {
        // Arrange
        AcceptanceCriteriaModel acceptanceCriteria =
            AcceptanceCriteriaModel(amount: 2, unit: 'unit');

        // Act
        AcceptanceCriteriaModel acceptanceCriteriaCopy =
            AcceptanceCriteriaModel.copy(acceptanceCriteria);

        // Assert (maybe just override the == operator)
        expect(
            acceptanceCriteriaCopy.amount, equals(acceptanceCriteria.amount));
        expect(acceptanceCriteriaCopy.unit, equals(acceptanceCriteria.unit));
      });
    });
  });
}
