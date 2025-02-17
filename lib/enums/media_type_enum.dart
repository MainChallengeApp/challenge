import 'package:challenge/exceptions/media_type_is_not_supported_exception.dart';

enum MediaTypeEnum {
  image('image'),
  note('note'),
  video('video');

  const MediaTypeEnum(this.text);

  final String text;

  static MediaTypeEnum fromString(String? string) {
    return MediaTypeEnum.values.firstWhere((e) => e.text == string,
        orElse: () => throw MediaTypeIsNotSupportedException(string));
  }
}
