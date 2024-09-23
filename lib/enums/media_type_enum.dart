import 'package:challenge/exceptions/media_type_is_not_supported_exception.dart';

enum MediaTypeEnum {
  image('image'),
  video('video'),
  text('text');

  const MediaTypeEnum(this.type);

  final String type;

  static MediaTypeEnum fromString(String? string) {
    return MediaTypeEnum.values.firstWhere((e) => e.type == string,
        orElse: () => throw MediaTypeIsNotSupportedException(string));
  }
}
