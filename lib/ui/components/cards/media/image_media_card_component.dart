import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:flutter/material.dart';

class ImageMediaCardComponent extends StatefulWidget {
  final MediaModel media;
  final bool isFullScreen;
  const ImageMediaCardComponent({
    super.key,
    required this.media,
    required this.isFullScreen,
  });

  @override
  State<ImageMediaCardComponent> createState() =>
      _ImageMediaCardComponentState();
}

class _ImageMediaCardComponentState extends State<ImageMediaCardComponent>
    with SingleTickerProviderStateMixin {
  final MediaService _mediaService = MediaService();
  late AnimationController _controller;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _borderRadiusAnimation = Tween<double>(
      begin: CardComponent.standardBorderRadius,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animateBorderRadius();
    return Align(
      alignment: Alignment.center,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        padding: widget.isFullScreen
            ? EdgeInsets.zero
            : const EdgeInsets.only(
                left: CardComponent.standardSideMargin,
                right: CardComponent.standardSideMargin,
                bottom: CardComponent.standardBottomMargin,
              ),
        child: AnimatedBuilder(
          animation: _borderRadiusAnimation,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
              child: child,
            );
          },
          child: _mediaService.isUrlLocal(widget.media.source)
              ? Image.asset(
                  widget.media.source,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(Icons.question_mark,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                )
              : Image.network(
                  widget.media.source,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(Icons.question_mark,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _animateBorderRadius() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFullScreen &&
          !_controller.isAnimating &&
          _controller.status != AnimationStatus.completed) {
        _controller.forward();
      } else if (!widget.isFullScreen &&
          !_controller.isAnimating &&
          _controller.status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    });
  }
}
