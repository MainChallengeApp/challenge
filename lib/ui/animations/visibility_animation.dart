import 'package:flutter/material.dart';

class VisibilityAnimation extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;

  const VisibilityAnimation({
    Key? key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<VisibilityAnimation> createState() => _VisibilityAnimationState();
}

class _VisibilityAnimationState extends State<VisibilityAnimation>
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
  void didUpdateWidget(VisibilityAnimation oldWidget) {
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
