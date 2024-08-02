import 'package:challenge/exceptions/frequency_type_is_not_supported_exception.dart';

enum FrequencyTypeEnum {
  time('time'),
  daily('daily'),
  weekday('weekday');

  final String text;

  const FrequencyTypeEnum(this.text);

  static FrequencyTypeEnum factory(String text) {
    return FrequencyTypeEnum.values.firstWhere((e) => e.text == text,
        orElse: () => throw FrequencyTypeIsNotSupportedException(text));
  }
}
