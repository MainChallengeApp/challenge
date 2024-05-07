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

  static String getDateAndTimeFormated(DateTime? date,
      {bool isYearVisible = true}) {
    if (date == null) {
      return '-';
    }
    String formatDate =
        '${isYearVisible ? date.year : ''}${isYearVisible ? '-' : ''}${date.month.toString().length == 1 ? '0' : ''}${date.month}-${date.day.toString().length == 1 ? '0' : ''}${date.day} ${date.hour.toString().length == 1 ? '0' : ''}${date.hour}:${date.minute.toString().length == 1 ? '0' : ''}${date.minute}';
    return formatDate;
  }
}
