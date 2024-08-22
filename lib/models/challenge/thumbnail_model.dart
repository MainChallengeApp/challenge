import 'package:challenge/enums/box_fit_enum.dart';

class ThumbnailModel {
  static String urlField = 'url';
  String url;

  static String scaleField = 'scale';
  double scale;

  static String fitField = 'fit';
  BoxFitEnum fit;

  ThumbnailModel(
      {this.url = '', this.scale = 1.0, this.fit = BoxFitEnum.cover});

  factory ThumbnailModel.fromDoc(Map<String, dynamic> doc) {
    return ThumbnailModel(
      url: doc[urlField],
      scale: doc[scaleField],
      fit: BoxFitEnum.fromString(doc[fitField]),
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      urlField: url,
      scaleField: scale,
      fitField: fit.string,
    };
  }

  void selectThumbnail(String source) {
    url = source;
    scale = 1.0;
    fit = BoxFitEnum.cover;
  }

  copy() {
    return ThumbnailModel(url: url, scale: scale, fit: fit);
  }
}
