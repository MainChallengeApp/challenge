import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class AddParticipantsOverviewComponent extends StatefulWidget {
  static const double removeParticipantsExtraSpace = 7;

  final String userId;
  final List<UserModel> participants;
  final Function(String)? onRemoveParticipant;

  const AddParticipantsOverviewComponent(
      {super.key,
      required this.participants,
      this.onRemoveParticipant,
      required this.userId});

  @override
  State<AddParticipantsOverviewComponent> createState() =>
      _AddParticipantsOverviewComponentState();
}

class _AddParticipantsOverviewComponentState
    extends State<AddParticipantsOverviewComponent> {
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
              children:
                  widget.participants.map((user) => userPicture(user)).toList(),
            ),
          ),
        ),
        const SpaceComponent(),
        currentAmountAndMaxAmount(),
      ],
    );
  }

  GestureDetector userPicture(UserModel user) {
    return GestureDetector(
      onTap: widget.onRemoveParticipant != null && user.id != widget.userId
          ? () => widget.onRemoveParticipant!(user.id)
          : null,
      child: Padding(
        padding: EdgeInsets.only(
            right: widget.onRemoveParticipant != null
                ? SpaceComponent.standardWidth -
                    AddParticipantsOverviewComponent
                        .removeParticipantsExtraSpace
                : SpaceComponent.standardWidth),
        child: Stack(
          children: [
            Padding(
              padding: widget.onRemoveParticipant != null
                  ? const EdgeInsets.only(
                      right: AddParticipantsOverviewComponent
                          .removeParticipantsExtraSpace,
                      top: AddParticipantsOverviewComponent
                          .removeParticipantsExtraSpace)
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
            removeUserIcon(user),
          ],
        ),
      ),
    );
  }

  Visibility removeUserIcon(UserModel user) {
    return Visibility(
      visible: widget.onRemoveParticipant != null && user.id != widget.userId,
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

  currentAmountAndMaxAmount() {
    return Column(
      children: [
        ContainerInListItemComponent(
          margin: widget.onRemoveParticipant != null
              ? const EdgeInsets.all(0).copyWith(
                  top: AddParticipantsOverviewComponent
                      .removeParticipantsExtraSpace)
              : const EdgeInsets.all(0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.participants.length.toString(),
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
                  DatabaseService.maxGroupChallengeMember.toString(),
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
