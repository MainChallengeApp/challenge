import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/frequency_model.dart';

class DesignUtil {
  static String doubleAsInt(double number) {
    if (number.toString().endsWith('.0')) {
      return number.toString().split('.')[0];
    }
    return number.toString();
  }

  static DateTime dateWithoutTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String dayDaysTimeOrTimes(FrequencyModel frequency) {
    return frequency.type == FrequencyTypeEnum.daily
        ? frequency.amount == 1
            ? 'Day'
            : 'Days'
        : frequency.type == FrequencyTypeEnum.time
            ? frequency.amount == 1
                ? 'Time'
                : 'Times'
            : '';
  }
}
