import 'package:flutter/material.dart';

class RefreshIndicatorComponent extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final Function onRefresh;

  const RefreshIndicatorComponent(
      {super.key,
      required this.child,
      required this.scrollController,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      displacement: 0,
      onRefresh: _onRefresh,
      child: child,
    );
  }

  Future<void> _onRefresh() async {
    await scrollController.animateTo(-35,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut);
    scrollController.animateTo(0,
        duration: const Duration(minutes: 1), curve: Curves.easeInOut);
    onRefresh();
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
