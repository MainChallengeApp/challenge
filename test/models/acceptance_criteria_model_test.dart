import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calcProgressRatio()', () {
    test('should be 1 when amount == progress', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 1,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          repetitions: []);

      // Act
      double progressRatio = acceptanceCriteria.calcProgressRatio();

      // Assert
      expect(progressRatio, equals(1));
    });

    test('should be 0.5 when amount = 2 * progress', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 2,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          repetitions: []);

      // Act
      double progressRatio = acceptanceCriteria.calcProgressRatio();

      // Assert
      expect(progressRatio, equals(0.5));
    });

    test('should be 1 when amount == 0', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 0,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          repetitions: []);

      // Act
      double progressRatio = acceptanceCriteria.calcProgressRatio();

      // Assert
      expect(progressRatio, equals(1));
    });
  });

  group('isComplete()', () {
    test('should be true when progress == amount', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 1,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          repetitions: []);

      // Act
      bool isComplete = acceptanceCriteria.isCompleted();

      // Assert
      expect(isComplete, equals(true));
    });

    test('should be true when progress > amount', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 1,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 2,
          repetitions: []);

      // Act
      bool isComplete = acceptanceCriteria.isCompleted();

      // Assert
      expect(isComplete, equals(true));
    });

    test('should not be true when progress < amount', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 10,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 2,
          repetitions: []);

      // Act
      bool isComplete = acceptanceCriteria.isCompleted();

      // Assert
      expect(isComplete, equals(false));
    });
  });

  group('copyAcceptanceCriteriaList()', () {
    test(
        'should copy acceptance criteria list when passing an acceptance criteria',
        () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          amount: 2,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          repetitions: []);

      // Act
      AcceptanceCriteriaModel acceptanceCriteriaCopy =
          AcceptanceCriteriaModel.copyAcceptanceCriteria(acceptanceCriteria);

      // Assert (maybe just override the == operator)
      expect(acceptanceCriteriaCopy.frequency.amount,
          equals(acceptanceCriteria.frequency.amount));
      expect(acceptanceCriteriaCopy.frequency.type,
          equals(acceptanceCriteria.frequency.type));
      expect(acceptanceCriteriaCopy.frequency.currentAmount,
          equals(acceptanceCriteria.frequency.currentAmount));
      expect(acceptanceCriteriaCopy.currentProgress,
          equals(acceptanceCriteria.currentProgress));
      expect(acceptanceCriteriaCopy.amount, equals(acceptanceCriteria.amount));
      expect(acceptanceCriteriaCopy.unit, equals(acceptanceCriteria.unit));
      expect(acceptanceCriteriaCopy.repetitions,
          equals(acceptanceCriteria.repetitions));
    });
  });
}
