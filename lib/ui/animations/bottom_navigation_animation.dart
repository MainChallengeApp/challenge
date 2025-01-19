import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:flutter/material.dart';

class BottomNavigationAnimation extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;

  const BottomNavigationAnimation({
    Key? key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<BottomNavigationAnimation> createState() =>
      _BottomNavigationAnimationState();
}

class _BottomNavigationAnimationState extends State<BottomNavigationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  final _tabProvider = getIt<TabProvider>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (!widget.isVisible) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(BottomNavigationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.reverse();
      } else {
        _tabProvider.setBottomNavigatorGoingDown(true);
        _controller.forward().then((_) {
          _tabProvider.setBottomNavigatorGoingDown(false);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Visibility(
              visible: _controller.value < 1.0,
              child: IntrinsicHeight(
                child: Container(
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
