import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('copyAcceptanceCriteriaList()', () {
    test(
        'should copy acceptance criteria list when passing an acceptance criteria',
        () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria =
          AcceptanceCriteriaModel(amount: 2, unit: 'unit');

      // Act
      AcceptanceCriteriaModel acceptanceCriteriaCopy =
          AcceptanceCriteriaModel.copyAcceptanceCriteria(acceptanceCriteria);

      // Assert (maybe just override the == operator)
      expect(acceptanceCriteriaCopy.amount, equals(acceptanceCriteria.amount));
      expect(acceptanceCriteriaCopy.unit, equals(acceptanceCriteria.unit));
    });
  });
}
