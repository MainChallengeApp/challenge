import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/exceptions/frequency_type_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FrequencyModel', () {
    FrequencyModel createMockFrequencyModel(
        {int? amount = 1, FrequencyTypeEnum type = FrequencyTypeEnum.time}) {
      return FrequencyModel(amount: amount, type: type);
    }

    group('FrequencyModel.empty()', () {
      test('should return a FrequencyModel with amount 1 and type time', () {
        // Arrange
        FrequencyModel expectedFrequencyModel = createMockFrequencyModel();
        // Act
        FrequencyModel actualFrequencyModel = FrequencyModel.empty();
        // Assert
        expect(actualFrequencyModel.amount, expectedFrequencyModel.amount);
        expect(actualFrequencyModel.type, expectedFrequencyModel.type);
      });
    });

    group('getMaxAmountOfRepetitions()', () {
      test('should return amount when type is time', () {
        // Arrange
        FrequencyModel frequencyModel = createMockFrequencyModel();
        // Act
        int? maxAmountOfRepetitions =
            frequencyModel.getMaxAmountOfRepetitions();
        // Assert
        expect(maxAmountOfRepetitions, frequencyModel.amount);
      });

      test('should return amount when type is daily', () {
        // Arrange
        FrequencyModel frequencyModel =
            createMockFrequencyModel(type: FrequencyTypeEnum.daily);
        // Act
        int? maxAmountOfRepetitions =
            frequencyModel.getMaxAmountOfRepetitions();
        // Assert
        expect(maxAmountOfRepetitions, frequencyModel.amount);
      });

      test(
          'should throw FrequencyTypeIsNotSupportedException when type is not supported',
          () {
        // Arrange
        FrequencyModel frequencyModel =
            createMockFrequencyModel(type: FrequencyTypeEnum.weekday);

        // Act & Assert
        expect(() => frequencyModel.getMaxAmountOfRepetitions(),
            throwsA(isA<FrequencyTypeIsNotSupportedException>()));
      });
    });

    group('typeToString()', () {
      test('should return Day when type is daily and amount is 1', () {
        // Arrange
        FrequencyModel frequencyModel =
            createMockFrequencyModel(type: FrequencyTypeEnum.daily);
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Day');
      });

      test('should return Days when type is daily and amount is not 1', () {
        // Arrange
        FrequencyModel frequencyModel =
            createMockFrequencyModel(type: FrequencyTypeEnum.daily, amount: 2);
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Days');
      });

      test('should return Time when type is time and amount is 1', () {
        // Arrange
        FrequencyModel frequencyModel = createMockFrequencyModel();
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Time');
      });

      test('should return Times when type is time and amount is not 1', () {
        // Arrange
        FrequencyModel frequencyModel = createMockFrequencyModel(amount: 2);
        // Act
        String typeToString = frequencyModel.typeToString();
        // Assert
        expect(typeToString, 'Times');
      });

      test(
          'should return throw FrequencyTypeIsNotSupportedException when type is not supported',
          () {
        // Arrange
        FrequencyModel frequencyModel =
            createMockFrequencyModel(type: FrequencyTypeEnum.weekday);

        // Act & Assert
        expect(() => frequencyModel.typeToString(),
            throwsA(isA<FrequencyTypeIsNotSupportedException>()));
      });
    });

    group('fromJson()', () {
      test('should return a FrequencyModel from a json', () {
        // Arrange
        Map<String, dynamic> json = {
          'amount': 1,
          'type': FrequencyTypeEnum.time.text
        };
        FrequencyModel expectedFrequencyModel = createMockFrequencyModel();
        // Act
        FrequencyModel actualFrequencyModel = FrequencyModel.fromDoc(json);
        // Assert
        expect(actualFrequencyModel.amount, expectedFrequencyModel.amount);
        expect(actualFrequencyModel.type, expectedFrequencyModel.type);
      });

      test(
          'should throw FrequencyTypeIsNotSupportedException when json is invalide',
          () {
        // Arrange
        Map<String, dynamic> json = {'amount': 1, 'type': 'invalid'};
        // Act & Assert
        expect(() => FrequencyModel.fromDoc(json),
            throwsA(isA<FrequencyTypeIsNotSupportedException>()));
      });

      test('should throw TypeError when json is invalide', () {
        // Arrange
        Map<String, dynamic> json = {'amount': 1.5, 'type': 'invalid'};
        // Act & Assert
        expect(() => FrequencyModel.fromDoc(json), throwsA(isA<TypeError>()));
      });
    });

    group('toJson()', () {
      test('should return a json from a FrequencyModel', () {
        // Arrange
        FrequencyModel frequencyModel = createMockFrequencyModel();
        Map<String, dynamic> expectedJson = {
          'amount': 1,
          'type': FrequencyTypeEnum.time.text
        };
        // Act
        Map<String, dynamic> actualJson = frequencyModel.toDoc();
        // Assert
        expect(actualJson, expectedJson);
      });

      test('should return a json with amount is null from a FrequencyModel',
          () {
        // Arrange
        FrequencyModel frequencyModel = createMockFrequencyModel(amount: null);
        Map<String, dynamic> expectedJson = {
          'amount': null,
          'type': FrequencyTypeEnum.time.text
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
        FrequencyModel frequencyModel = createMockFrequencyModel();
        // Act
        FrequencyModel copyFrequencyModel = frequencyModel.copy();
        // Assert
        expect(copyFrequencyModel.amount, frequencyModel.amount);
        expect(copyFrequencyModel.type, frequencyModel.type);
      });
    });
  });
}
