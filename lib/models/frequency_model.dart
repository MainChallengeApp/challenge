import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/exceptions/frequency_type_is_not_supported_exception.dart';

class FrequencyModel {
  int? amount;
  FrequencyTypeEnum type;

  FrequencyModel({this.amount, required this.type});

  FrequencyModel.empty({this.amount = 1, this.type = FrequencyTypeEnum.time});

  int? getMaxAmountOfRepetitions() {
    if (amount == null) {
      return null;
    }

    if (type == FrequencyTypeEnum.daily) {
      return amount;
    } else if (type == FrequencyTypeEnum.time) {
      return amount;
    } else {
      throw FrequencyTypeIsNotSupportedException(type.text);
    }
  }

  String typeToString() {
    return type == FrequencyTypeEnum.daily
        ? amount == 1
            ? 'Day'
            : 'Days'
        : type == FrequencyTypeEnum.time
            ? amount == 1
                ? 'Time'
                : 'Times'
            : throw FrequencyTypeIsNotSupportedException(type.text);
  }

  static FrequencyModel fromJson(json) {
    try {
      return FrequencyModel(
          amount: json['amount'],
          type: FrequencyTypeEnum.factory(json['type']));
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type.text,
    };
  }

  FrequencyModel copy() {
    return FrequencyModel(type: type, amount: amount);
  }
}
