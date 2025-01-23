import 'package:challenge/services/media_service.dart';
import 'package:flutter/material.dart';

class AppIconComponent extends StatelessWidget {
  static const String path = 'assets/icons/challenge_icon_black.png';
  static const double scale = 0.6;

  const AppIconComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaService()
        .getImage(context, 'assets/icons/app_icon.png', scale: 0.6);
  }
}
