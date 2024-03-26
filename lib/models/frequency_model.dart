import 'package:challenge/enums/frequency_type_enum.dart.dart';

class FrequencyModel {
  int? amount;
  int currentAmount;
  FrequencyTypeEnum type;

  FrequencyModel({this.amount, required this.type, this.currentAmount = 0});

  setAmountByStartAndEndDate(DateTime startDate, DateTime endDate) {
    amount = startDate.difference(endDate).inDays;
  }

  static fromJson(json) {
    return FrequencyModel(
        amount: json['amount'],
        type: FrequencyTypeEnum.factory(json['type']),
        currentAmount: json['currentAmount'] ?? 0);
  }

  static Map<String, dynamic> toJson(FrequencyModel frequency) {
    return {
      'amount': frequency.amount,
      'type': frequency.type.toString2(),
      'currentAmount': frequency.currentAmount
    };
  }

  static copyFrequency(FrequencyModel frequency) {
    return FrequencyModel(
        type: frequency.type,
        amount: frequency.amount,
        currentAmount: frequency.currentAmount);
  }
}
