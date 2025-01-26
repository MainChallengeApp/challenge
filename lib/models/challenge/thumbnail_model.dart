import 'package:challenge/enums/box_fit_enum.dart';

class ThumbnailModel {
  String url;
  static const String urlField = 'url';

  double scale;
  static const String scaleField = 'scale';

  BoxFitEnum fit;
  static const String fitField = 'fit';

  bool isBackgroundBlurred;
  static const String isBackgroundBlurredField = 'isBackgroundBlurred';

  ThumbnailModel(
      {this.url = '',
      double? scale,
      BoxFitEnum? fit,
      this.isBackgroundBlurred = false})
      : fit = fit ?? BoxFitEnum.cover,
        scale = scale ?? 1.0;

  factory ThumbnailModel.fromDoc(Map<String, dynamic> doc) {
    return ThumbnailModel(
      url: doc[urlField],
      scale: doc[scaleField],
      fit: BoxFitEnum.fromString(doc[fitField]),
      isBackgroundBlurred: doc[isBackgroundBlurredField] ?? false,
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      urlField: url,
      scaleField: scale,
      fitField: fit.string,
      isBackgroundBlurredField: isBackgroundBlurred,
    };
  }

  void selectThumbnail(String source) {
    url = source;
    scale = 1.0;
    fit = BoxFitEnum.cover;
  }

  copy() {
    return ThumbnailModel(
        url: url,
        scale: scale,
        fit: fit,
        isBackgroundBlurred: isBackgroundBlurred);
  }
}
