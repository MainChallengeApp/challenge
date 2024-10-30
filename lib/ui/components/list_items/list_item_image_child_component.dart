import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemImageChildComponent extends StatelessWidget {
  ListItemImageChildComponent(
      {super.key,
      this.onTap,
      required this.url,
      required this.child,
      this.fit,
      this.scale,
      this.icon = Icons.question_mark,
      this.endActionPane});

  final void Function()? onTap;
  final ActionPane? Function(Function)? endActionPane;

  final String? url;
  final BoxFit? fit;
  final double? scale;

  final Widget child;
  final IconData icon;

  final mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      endActionPane: endActionPane,
      onTap: onTap,
      child: Row(
        children: [
          ImageInListItemComponent(
              icon: icon, url: url, fit: fit, scale: scale),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
