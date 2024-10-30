import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class AddMemberOverviewComponent extends StatefulWidget {
  final List<UserModel> members;

  const AddMemberOverviewComponent({super.key, required this.members});

  @override
  State<AddMemberOverviewComponent> createState() =>
      _AddMemberOverviewComponentState();
}

class _AddMemberOverviewComponentState
    extends State<AddMemberOverviewComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.members
                  .map((user) => Container(
                        margin: const EdgeInsets.only(
                            right: SpaceComponent.staticWidth),
                        width: ListItemIconTextComponent.iconContainerSize,
                        child: Column(
                          children: [
                            ImageInListItemComponent(
                              icon: IconEnum.user.icon,
                              url: user.pictureUrl,
                              margin: const EdgeInsets.all(0),
                            ),
                            const SpaceComponent(
                              height: 5,
                            ),
                            Text(
                              user.username,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SpaceComponent(),
        ContainerInListItemComponent(
          margin: const EdgeInsets.all(0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.members.length.toString(),
                  overflow: TextOverflow.ellipsis,
                  // textHeightBehavior: const TextHeightBehavior(
                  //     applyHeightToFirstAscent: false,
                  //     applyHeightToLastDescent: false),
                  style: Theme.of(context)
                      .textTheme
                      .textInputSmall
                      .copyWith(fontSize: 9.5),
                ),
                Container(
                  height: 1,
                  width: null,
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Text(
                  '100',
                  overflow: TextOverflow.ellipsis,
                  // textHeightBehavior: const TextHeightBehavior(
                  //     applyHeightToFirstAscent: false,
                  //     applyHeightToLastDescent: false),
                  style: Theme.of(context)
                      .textTheme
                      .textInputSmall
                      .copyWith(fontSize: 9.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
