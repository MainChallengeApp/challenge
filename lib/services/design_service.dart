class DesignService {
  static String doubleAsIntString(double number) {
    if (number.toString().endsWith('.0')) {
      return number.toString().split('.')[0];
    }
    return number.toString();
  }

  static DateTime dateWithoutTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
