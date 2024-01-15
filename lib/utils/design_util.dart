class DesignUtil {
  static String doubleAsInt(double number) {
    if (number.toString().endsWith('.0')) {
      return number.toString().split('.')[0];
    }
    return number.toString();
  }
}
