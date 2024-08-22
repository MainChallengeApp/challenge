import 'package:flutter/material.dart';

enum BoxFitEnum {
  cover(string: 'cover', fit: BoxFit.cover),
  contain(string: 'contain', fit: BoxFit.contain),
  ;

  final String string;
  final BoxFit fit;

  const BoxFitEnum({required this.string, required this.fit});

  factory BoxFitEnum.fromString(String? fit) {
    return BoxFitEnum.values.firstWhere(
      (e) => e.string == fit,
      orElse: () => BoxFitEnum.contain,
    );
  }
}
