import 'package:flutter/material.dart';

enum IconEnum { progress, delete, newChallenge, shuffle }

extension IconEnumExtension on IconEnum {
  IconData get icon {
    switch (this) {
      case IconEnum.progress:
        return Icons.bolt_rounded;
      case IconEnum.delete:
        return Icons.delete;
      case IconEnum.newChallenge:
        return Icons.add_rounded;
      case IconEnum.shuffle:
        return Icons.shuffle_rounded;
    }
  }
}
