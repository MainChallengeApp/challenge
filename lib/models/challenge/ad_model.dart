class AdModel {
  final String text;
  static const String textField = 'text';

  final String url;
  static const String urlField = 'url';

  AdModel({required this.text, required this.url});

  factory AdModel.fromDoc(Map<String, dynamic> json) {
    try {
      return AdModel(
        text: json[textField] as String,
        url: json[urlField] as String,
      );
    } catch (e) {
      throw FormatException('Invalid JSON format for AdModel: $json');
    }
  }

  Map<String, dynamic> toDoc() {
    return {textField: text, urlField: url};
  }

  AdModel copy() {
    return AdModel(text: text, url: url);
  }
}
