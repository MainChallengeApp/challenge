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

  static String dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  static String timeFormat(DateTime date) {
    return '${date.hour <= 9 ? '0' : ''}${date.hour}:${date.minute <= 9 ? '0' : ''}${date.minute}';
  }
}
