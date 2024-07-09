import 'package:flutter/material.dart';

enum IconEnum { progress, delete }

extension IconEnumExtension on IconEnum {
  IconData get icon {
    switch (this) {
      case IconEnum.progress:
        return Icons.bolt_rounded;
      case IconEnum.delete:
        return Icons.delete;
    }
  }
}
