import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
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
          ContainerInContainerComponent(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.only(right: 10),
              height: ListItemIconTextComponent.iconContainerSize,
              width: ListItemIconTextComponent.iconContainerSize,
              borderRadius: const BorderRadius.all(Radius.circular(
                  ListItemIconTextComponent.standardIconRadius)),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(
                      ListItemIconTextComponent.standardIconRadius)),
                  child: Transform.scale(
                    scale: scale ?? 1,
                    child: url == null
                        ? Center(
                            child: Icon(icon,
                                color: Theme.of(context).colorScheme.tertiary),
                          )
                        : mediaService.isUrlLocal(url!)
                            ? Image.asset(url!,
                                fit: fit ?? BoxFitEnum.cover.fit,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(icon,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ))
                            : Image.network(url!,
                                fit: fit ?? BoxFitEnum.cover.fit,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(icon,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    )),
                  ))),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
