import 'package:challenge/exceptions/frequency_type_is_not_supported_exception.dart';

enum FrequencyTypeEnum {
  time('time'),
  daily('daily');

  final String text;

  const FrequencyTypeEnum(this.text);

  static FrequencyTypeEnum fromString(String text) {
    return FrequencyTypeEnum.values.firstWhere((e) => e.text == text,
        orElse: () => throw FrequencyTypeIsNotSupportedException(text));
  }
}
