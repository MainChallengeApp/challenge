import 'package:flutter/material.dart';

class AppBarAnimation extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;

  const AppBarAnimation({
    Key? key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<AppBarAnimation> createState() => _AppBarAnimationState();
}

class _AppBarAnimationState extends State<AppBarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _updateOffsetAnimation();
    if (!widget.isVisible) {
      _controller.value = 1.0;
    }
  }

  void _updateOffsetAnimation() {
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void didUpdateWidget(AppBarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.reverse();
      } else {
        _controller.forward();
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
          alignment: Alignment.topCenter,
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
