class UtilService {
  static String doubleAsIntString(double number) {
    if (number.toString().endsWith('.0')) {
      return number.toString().split('.')[0];
    }
    return number.toString();
  }

  static DateTime dateWithoutTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime? getMinDate(List<DateTime?> dates) {
    dates.removeWhere((element) => element == null);
    List<DateTime> datesWithoutNull = dates.map((e) => e!).toList();
    if (datesWithoutNull.isEmpty) {
      return null;
    }
    DateTime minDate = datesWithoutNull.reduce(
        (currentMin, date) => date.isBefore(currentMin) ? date : currentMin);
    return minDate;
  }

  static DateTime? getMaxDate(List<DateTime?> dates) {
    dates.removeWhere((element) => element == null);
    List<DateTime> datesWithoutNull = dates.map((e) => e!).toList();
    if (datesWithoutNull.isEmpty) {
      return null;
    }
    DateTime maxDate = datesWithoutNull.reduce(
        (currentMax, date) => date.isAfter(currentMax) ? date : currentMax);
    return maxDate;
  }

  static String dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  static String timeFormat(DateTime date) {
    return '${date.hour <= 9 ? '0' : ''}${date.hour}:${date.minute <= 9 ? '0' : ''}${date.minute}';
  }
}
