import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
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
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _borderRadiusAnimation,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(_borderRadiusAnimation.value),
                  child: child,
                );
              },
              child: _image(),
            ),
            Positioned(bottom: 0, left: 0, right: 0, child: _title())
          ],
        ),
      ),
    );
  }

  _title() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      opacity: widget.isFullScreen ? 0 : 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(
          children: [
            ContainerInContainerTextComponent(
                height: SmallContainerInListItemComponent.height,
                margin: const EdgeInsets.all(CardComponent.standardPadding),
                text: widget.media.title),
          ],
        ),
      ),
    );
  }

  _image() {
    return _mediaService.getImage(context, widget.media.source,
        fit: BoxFit.contain, icon: Icons.question_mark);
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
