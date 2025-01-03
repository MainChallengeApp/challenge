import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final String title;

  const TitleComponent({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(
              left: CustomContainerComponent.standardPadding + 1),
          child: SizedBox(
            height: SmallContainerInListItemComponent
                .height, // to prevent jumping on start
            child: Text(title,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left),
          ),
        ),
      ),
    );
  }
}
