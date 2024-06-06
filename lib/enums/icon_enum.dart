import 'package:flutter/material.dart';

enum IconEnum { progress }

extension IconEnumExtension on IconEnum {
  IconData get icon {
    switch (this) {
      case IconEnum.progress:
        return Icons.bolt_rounded;
    }
  }
}
