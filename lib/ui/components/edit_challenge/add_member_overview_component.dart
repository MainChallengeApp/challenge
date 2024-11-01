import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class AddMemberOverviewComponent extends StatefulWidget {
  static const double removeMemberExtraSpace = 7;

  final List<UserModel> members;
  final Function(String)? onRemoveMember;

  const AddMemberOverviewComponent(
      {super.key, required this.members, this.onRemoveMember});

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
                  .map((user) => userPicture(user, context))
                  .toList(),
            ),
          ),
        ),
        const SpaceComponent(),
        currentAmountAndMaxAmount(context),
      ],
    );
  }

  GestureDetector userPicture(UserModel user, BuildContext context) {
    return GestureDetector(
      onTap: widget.onRemoveMember != null
          ? () => widget.onRemoveMember!(user.id)
          : null,
      child: Padding(
        padding: EdgeInsets.only(
            right: widget.onRemoveMember != null
                ? SpaceComponent.staticWidth -
                    AddMemberOverviewComponent.removeMemberExtraSpace
                : SpaceComponent.staticWidth),
        child: Stack(
          children: [
            Padding(
              padding: widget.onRemoveMember != null
                  ? const EdgeInsets.only(
                      right: AddMemberOverviewComponent.removeMemberExtraSpace,
                      top: AddMemberOverviewComponent.removeMemberExtraSpace)
                  : const EdgeInsets.all(0),
              child: SizedBox(
                width: ListItemIconTextComponent.iconContainerSize,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageInListItemComponent(
                      icon: IconEnum.user.icon,
                      url: user.pictureUrl,
                      margin: const EdgeInsets.all(0),
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
              ),
            ),
            removeUserIcon(context),
          ],
        ),
      ),
    );
  }

  Visibility removeUserIcon(BuildContext context) {
    return Visibility(
      visible: widget.onRemoveMember != null,
      child: Positioned(
        right: 0,
        top: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(100), // circle
          ),
          child: Icon(
            IconEnum.removeFullCircle.icon,
            color: Theme.of(context).colorScheme.tertiary,
            size: 20,
            weight: 10,
          ),
        ),
      ),
    );
  }

  currentAmountAndMaxAmount(BuildContext context) {
    return Column(
      children: [
        ContainerInListItemComponent(
          margin: widget.onRemoveMember != null
              ? const EdgeInsets.all(0).copyWith(
                  top: AddMemberOverviewComponent.removeMemberExtraSpace)
              : const EdgeInsets.all(0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.members.length.toString(),
                  overflow: TextOverflow.ellipsis,
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
                  style: Theme.of(context)
                      .textTheme
                      .textInputSmall
                      .copyWith(fontSize: 9.5),
                ),
              ],
            ),
          ),
        ),
        Text(
          // just to not make it jump
          ' ',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.normal),
        )
      ],
    );
  }
}
