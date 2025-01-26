import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class ImageInListItemComponent extends StatelessWidget {
  final String? url;
  final double? scale;
  final BoxFit? fit;
  final IconData? icon;
  final double? size;
  final Color? iconColor;
  final EdgeInsets? margin;

  ImageInListItemComponent(
      {super.key,
      this.icon,
      this.size,
      this.iconColor,
      this.url,
      this.scale,
      this.fit,
      this.margin});

  final _mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return ContainerInListItemComponent(
        margin: margin,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(ListItemIconTextComponent.standardIconRadius)),
            child: _mediaService.getImage(context, url,
                fit: BoxFit.cover, scale: scale, icon: icon)));
  }
}
