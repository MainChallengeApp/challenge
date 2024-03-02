import 'package:challenge/enums/frequency_type_enum.dart.dart';

class FrequencyModel {
  int? amount;
  int? currentAmount;
  FrequencyTypeEnum type;

  FrequencyModel(
      {this.amount, required this.type, required this.currentAmount});

  setAmountByStartAndEndDate(DateTime startDate, DateTime endDate) {
    amount = startDate.difference(endDate).inDays;
  }

  static fromJson(json) {
    return FrequencyModel(
        amount: json['amount'],
        type: FrequencyTypeEnum.factory(json['type']),
        currentAmount: json['currentAmount']);
  }

  static Map<String, dynamic> toJson(FrequencyModel frequency) {
    return {
      'amount': frequency.amount ?? 0,
      'type': frequency.type.toString2(),
      'currentAmount': frequency.currentAmount ?? 0
    };
  }

  static copyFrequency(FrequencyModel frequency) {
    return FrequencyModel(
        type: frequency.type,
        amount: frequency.amount,
        currentAmount: frequency.currentAmount);
  }
}
