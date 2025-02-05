class ErrorTextService {
  static showErrorText(Function reloadPage, Map<String, String?> errorTexts,
      String key, String? errorText) {
    reloadPage(() {
      errorTexts[key] = null;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      reloadPage(() {
        errorTexts[key] = errorText;
      });
    });
  }
}
