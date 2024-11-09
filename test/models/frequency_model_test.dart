import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/exceptions/frequency_type_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

FrequencyModel mockFrequencyModel({int? amount, FrequencyTypeEnum? type}) {
  return FrequencyModel(
      amount: amount ?? FakerService.integer(),
      type: type ?? FakerService.randomObject(FrequencyTypeEnum.values));
}

void main() {
  group('FrequencyModel', () {
    group('FrequencyModel.empty()', () {
      test('should return a FrequencyModel with amount 1 and type time', () {
        // Act
        FrequencyModel actualFrequencyModel = FrequencyModel.empty();
        // Assert
        expect(actualFrequencyModel.amount, 1);
        expect(actualFrequencyModel.type, FrequencyTypeEnum.time);
      });
    });

    group('getMaxAmountOfRepetitions()', () {
      test('should return amount when type is time', () {
        // Arrange
        FrequencyModel frequencyModel = mockFrequencyModel();
        // Act
        int? maxAmountOfRepetitions =
            frequencyModel.getMaxAmountOfRepetitions();
        // Assert
        expect(maxAmountOfRepetitions, frequencyModel.amount);
      });

      test('should return amount when type is daily', () {
        // Arrange
        FrequencyModel frequencyModel =
            mockFrequencyModel(type: FrequencyTypeEnum.daily);
        // Act
        int? maxAmountOfRepetitions =
            frequencyModel.getMaxAmountOfRepetitions();
        // Assert
        expect(maxAmountOfRepetitions, frequencyModel.amount);
      });
    });

    group('typeToString()', () {
      test('should return Day when type is daily and amount is 1', () {
        // Arrange
        FrequencyModel frequencyModel =
            mockFrequencyModel(amount: 1, type: FrequencyTypeEnum.daily);
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Day');
      });

      test('should return Days when type is daily and amount is not 1', () {
        // Arrange
        FrequencyModel frequencyModel = mockFrequencyModel(
            type: FrequencyTypeEnum.daily,
            amount: FakerService.integer(min: 2));
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Days');
      });

      test('should return Time when type is time and amount is 1', () {
        // Arrange
        FrequencyModel frequencyModel =
            mockFrequencyModel(amount: 1, type: FrequencyTypeEnum.time);
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Time');
      });

      test('should return Times when type is time and amount is not 1', () {
        // Arrange
        FrequencyModel frequencyModel = mockFrequencyModel(
            amount: FakerService.integer(min: 2), type: FrequencyTypeEnum.time);
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Times');
      });
    });

    group('fromDoc()', () {
      test('should return a FrequencyModel from a doc', () {
        // Arrange
        int amount = FakerService.integer();
        FrequencyTypeEnum type =
            FakerService.randomObject(FrequencyTypeEnum.values);
        Map<String, dynamic> json = {'amount': amount, 'type': type.text};
        // Act
        FrequencyModel actualFrequencyModel = FrequencyModel.fromDoc(json);
        // Assert
        expect(actualFrequencyModel.amount, amount);
        expect(actualFrequencyModel.type, type);
      });

      test(
          'should throw FrequencyTypeIsNotSupportedException when json is invalide',
          () {
        // Arrange
        Map<String, dynamic> json = {'amount': 1, 'type': 'invalid'};
        // Assert
        expect(() => FrequencyModel.fromDoc(json),
            throwsA(isA<FrequencyTypeIsNotSupportedException>()));
      });

      test('should throw TypeError when json is invalide', () {
        // Arrange
        Map<String, dynamic> json = {'amount': 1.5, 'type': 'invalid'};
        // Assert
        expect(() => FrequencyModel.fromDoc(json), throwsA(isA<TypeError>()));
      });
    });

    group('toDoc()', () {
      test('should return a json from a FrequencyModel', () {
        // Arrange
        FrequencyModel frequencyModel = mockFrequencyModel();
        Map<String, dynamic> expectedJson = {
          'amount': frequencyModel.amount,
          'type': frequencyModel.type.text
        };
        // Act
        Map<String, dynamic> actualJson = frequencyModel.toDoc();
        // Assert
        expect(actualJson, expectedJson);
      });

      test('should return a doc with amount is null from a FrequencyModel', () {
        // Arrange
        FrequencyModel frequencyModel = mockFrequencyModel();
        frequencyModel.amount = null;
        Map<String, dynamic> expectedJson = {
          'amount': frequencyModel.amount,
          'type': frequencyModel.type.text
        };
        // Act
        Map<String, dynamic> actualJson = frequencyModel.toDoc();
        // Assert
        expect(actualJson, expectedJson);
      });
    });

    group('copy()', () {
      test('should return a copy of a FrequencyModel', () {
        // Arrange
        FrequencyModel frequencyModel = mockFrequencyModel();
        // Act
        FrequencyModel copyFrequencyModel = frequencyModel.copy();
        // Assert
        expect(copyFrequencyModel.amount, frequencyModel.amount);
        expect(copyFrequencyModel.type, frequencyModel.type);
      });
    });
  });
}
