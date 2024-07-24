import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/utils/design_util.dart';

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
      return 0;
    }
  }

  setAmountByStartAndEndDate(DateTime startDate, DateTime endDate) {
    amount = startDate.difference(endDate).inDays;
  }

  String dayDaysTimeOrTimes() {
    return type == FrequencyTypeEnum.daily
        ? amount == 1
            ? 'Day'
            : 'Days'
        : type == FrequencyTypeEnum.time
            ? amount == 1
                ? 'Time'
                : 'Times'
            : '';
  }

  static fromJson(json) {
    return FrequencyModel(
        amount: json['amount'], type: FrequencyTypeEnum.factory(json['type']));
  }

  static Map<String, dynamic> toJson(FrequencyModel frequency) {
    return {
      'amount': frequency.amount,
      'type': frequency.type.toString2(),
    };
  }

  static copyFrequency(FrequencyModel frequency) {
    return FrequencyModel(type: frequency.type, amount: frequency.amount);
  }

  nextIn() {
    if (type == FrequencyTypeEnum.daily) {
      Duration difference = DesignUtil.dateWithoutTime(
              DateTime.now().add(const Duration(days: 1)))
          .difference(DateTime.now());
      if (difference.inHours <= 0) {
        return "${difference.inMinutes} min";
      }
      return "${difference.inHours.toString()} h";
    }
  }
}
