import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:flutter/material.dart';

class SnackBarComponent {
  static final _tabProvider = getIt<TabProvider>();

  static showSnackBar(String text, {BuildContext? context}) {
    BuildContext? buildContext =
        _tabProvider.getCurrentContext(context: context);
    ScaffoldMessenger.of(buildContext).clearSnackBars();
    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 3000),
    ));
  }
}
