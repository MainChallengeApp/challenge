import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calcProgressRatio()', () {
    test('should be 1 when amount == progress', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          id: 1,
          title: 'title',
          amount: 1,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          progress: []);

      // Act
      double progressRatio = acceptanceCriteria.calcProgressRatio();

      // Assert
      expect(progressRatio, equals(1));
    });

    test('should be 0.5 when amount = 2 * progress', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          id: 1,
          title: 'title',
          amount: 2,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          progress: []);

      // Act
      double progressRatio = acceptanceCriteria.calcProgressRatio();

      // Assert
      expect(progressRatio, equals(0.5));
    });

    test('should be 1 when amount == 0', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          id: 1,
          title: 'title',
          amount: 0,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          progress: []);

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
          id: 1,
          title: 'title',
          amount: 1,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 1,
          progress: []);

      // Act
      bool isComplete = acceptanceCriteria.isCompleted();

      // Assert
      expect(isComplete, equals(true));
    });

    test('should be true when progress > amount', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          id: 1,
          title: 'title',
          amount: 1,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 2,
          progress: []);

      // Act
      bool isComplete = acceptanceCriteria.isCompleted();

      // Assert
      expect(isComplete, equals(true));
    });

    test('should not be true when progress < amount', () {
      // Arrange
      AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
          id: 1,
          title: 'title',
          amount: 10,
          unit: 'unit',
          frequency:
              FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
          tracking: 'tracking',
          currentProgress: 2,
          progress: []);

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
      List<AcceptanceCriteriaModel> acceptanceCriterias = [
        AcceptanceCriteriaModel(
            id: 1,
            title: 'title',
            amount: 2,
            unit: 'unit',
            frequency:
                FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
            tracking: 'tracking',
            currentProgress: 1,
            progress: []),
        AcceptanceCriteriaModel(
            id: 2,
            title: 'title',
            amount: 1,
            unit: 'unit',
            frequency:
                FrequencyModel(type: FrequencyTypeEnum.daily, currentAmount: 0),
            tracking: 'tracking',
            currentProgress: 1,
            progress: [])
      ];

      // Act
      List<AcceptanceCriteriaModel> acceptanceCriteriasCopy =
          AcceptanceCriteriaModel.copyAcceptanceCriterias(acceptanceCriterias);

      // Assert (maybe just override the == operator)
      expect(acceptanceCriteriasCopy.length, equals(2));
      expect(acceptanceCriteriasCopy[0].id, equals(acceptanceCriterias[0].id));
      expect(acceptanceCriteriasCopy[0].frequency.amount,
          equals(acceptanceCriterias[0].frequency.amount));
      expect(acceptanceCriteriasCopy[0].frequency.type,
          equals(acceptanceCriterias[0].frequency.type));
      expect(acceptanceCriteriasCopy[0].frequency.currentAmount,
          equals(acceptanceCriterias[0].frequency.currentAmount));
      expect(acceptanceCriteriasCopy[0].currentProgress,
          equals(acceptanceCriterias[0].currentProgress));
      expect(acceptanceCriteriasCopy[0].title,
          equals(acceptanceCriterias[0].title));
      expect(acceptanceCriteriasCopy[0].amount,
          equals(acceptanceCriterias[0].amount));
      expect(
          acceptanceCriteriasCopy[0].unit, equals(acceptanceCriterias[0].unit));
      expect(acceptanceCriteriasCopy[0].progress,
          equals(acceptanceCriterias[0].progress));

      expect(acceptanceCriteriasCopy[1].id, equals(acceptanceCriterias[1].id));
      expect(acceptanceCriteriasCopy[1].frequency.amount,
          equals(acceptanceCriterias[1].frequency.amount));
      expect(acceptanceCriteriasCopy[1].frequency.type,
          equals(acceptanceCriterias[1].frequency.type));
      expect(acceptanceCriteriasCopy[1].frequency.currentAmount,
          equals(acceptanceCriterias[1].frequency.currentAmount));
      expect(acceptanceCriteriasCopy[1].currentProgress,
          equals(acceptanceCriterias[1].currentProgress));
      expect(acceptanceCriteriasCopy[1].title,
          equals(acceptanceCriterias[1].title));
      expect(acceptanceCriteriasCopy[1].amount,
          equals(acceptanceCriterias[1].amount));
      expect(
          acceptanceCriteriasCopy[1].unit, equals(acceptanceCriterias[1].unit));
      expect(acceptanceCriteriasCopy[1].progress,
          equals(acceptanceCriterias[1].progress));
    });
  });
}
