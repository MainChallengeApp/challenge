import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

ThumbnailModel mockThumbnailModel({
  String? url,
  double? scale,
  BoxFitEnum? fit,
}) {
  return ThumbnailModel(
    url: url ?? FakerService.url(),
    scale: scale ?? FakerService.decimal(),
    fit: fit ?? FakerService.randomObject(BoxFitEnum.values),
  );
}

void main() {
  group('ThumbnailModel', () {
    group('fromDoc()', () {
      test('should return thumbnail model from document', () {
        // arrange
        ThumbnailModel thumbnail = mockThumbnailModel();
        Map<String, dynamic> doc = thumbnail.toDoc();
        // act
        final result = ThumbnailModel.fromDoc(doc);
        // assert
        expect(result.url, thumbnail.url);
        expect(result.scale, thumbnail.scale);
        expect(result.fit.string, thumbnail.fit.string);
      });
    });

    group('toDoc()', () {
      test('should return document of participant model', () {
        // arrange
        ThumbnailModel thumbnailModel = mockThumbnailModel();
        // act
        final result = thumbnailModel.toDoc();
        // assert
        expect(result[ThumbnailModel.urlField], thumbnailModel.url);
        expect(result[ThumbnailModel.scaleField], thumbnailModel.scale);
        expect(result[ThumbnailModel.fitField], thumbnailModel.fit.string);
      });
    });

    group('selectThumbnail()', () {
      test('should select thumbnail', () {
        // arrange
        ThumbnailModel thumbnail = mockThumbnailModel();
        String source = FakerService.url();
        // act
        thumbnail.selectThumbnail(source);
        // assert
        expect(thumbnail.url, source);
        expect(thumbnail.scale, 1.0);
        expect(thumbnail.fit, BoxFitEnum.cover);
      });
    });

    group('copy()', () {
      test('should return copy of thumbnail model', () {
        // arrange
        ThumbnailModel thumbnail = mockThumbnailModel();
        // act
        final thumbnailCopy = thumbnail.copy();
        // assert
        expect(thumbnailCopy.url, thumbnail.url);
        expect(thumbnailCopy.scale, thumbnail.scale);
        expect(thumbnailCopy.fit, thumbnail.fit);
      });
    });
  });
}
