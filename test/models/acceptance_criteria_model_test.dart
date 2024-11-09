import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

AcceptanceCriteriaModel mockAcceptanceCriteriaModel({
  double? amount,
  String? unit,
}) {
  return AcceptanceCriteriaModel(
      amount: amount ?? FakerService.decimal(),
      unit: unit ?? FakerService.word());
}

void main() {
  group('AcceptanceCriteriaModel', () {
    group('empty()', () {
      test('should return an empty acceptance criteria', () {
        // Act
        AcceptanceCriteriaModel emptyAcceptanceCriteria =
            AcceptanceCriteriaModel.empty();

        // Assert
        expect(emptyAcceptanceCriteria.amount, equals(1.0));
        expect(emptyAcceptanceCriteria.unit, equals(''));
      });
    });

    group('fromDoc()', () {
      test('should return an acceptance criteria from a json', () {
        // Arrange
        double amount = FakerService.decimal();
        String unit = FakerService.word();
        Map<String, dynamic> doc = {'amount': amount, 'unit': unit};

        // Act
        AcceptanceCriteriaModel acceptanceCriteriaFromJson =
            AcceptanceCriteriaModel.fromDoc(doc);

        // Assert
        expect(acceptanceCriteriaFromJson.amount, equals(amount));
        expect(acceptanceCriteriaFromJson.unit, equals(unit));
      });
    });

    test('should throw error when passing an invalid json', () {
      // Arrange
      Map<String, dynamic> json = {
        'amount': FakerService.decimal().toString(),
        'unit': FakerService.word()
      };

      // Assert & // Act
      expect(() => AcceptanceCriteriaModel.fromDoc(json),
          throwsA(isA<TypeError>()));
    });
  });

  group('toJson()', () {
    test('should return a json from an acceptance criteria', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria =
          mockAcceptanceCriteriaModel();
      Map<String, dynamic> expectedJson = {
        'amount': acceptanceCriteria.amount,
        'unit': acceptanceCriteria.unit
      };

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
          mockAcceptanceCriteriaModel();

      // Act
      AcceptanceCriteriaModel acceptanceCriteriaCopy =
          acceptanceCriteria.copy();

      // Assert (maybe just override the == operator)
      expect(acceptanceCriteriaCopy.amount, equals(acceptanceCriteria.amount));
      expect(acceptanceCriteriaCopy.unit, equals(acceptanceCriteria.unit));
    });
  });
}
