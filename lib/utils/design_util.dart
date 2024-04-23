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

  static String getDateAndTimeFormated(DateTime? date) {
    if (date == null) {
      return '';
    }
    String formattedDate =
        '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}';
    return formattedDate;
  }
}
