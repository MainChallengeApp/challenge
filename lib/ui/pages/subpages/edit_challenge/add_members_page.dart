import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/edit_challenge/add_member_overview_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMembersPage extends StatefulWidget {
  final String preTitle;
  final List<UserModel> members;

  const AddMembersPage(
      {super.key, required this.preTitle, required this.members});

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  String title = 'Add Members';

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  final textEditingController = TextEditingController();

  late List<UserModel> editMembers = List.from(widget.members);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SpaceColumnComponent(
                        child: ListItemSearchBarComponent(
                            textEditingController: textEditingController)),
                    SpaceColumnComponent(
                        child: ListItemContainerComponent(
                            padding: const EdgeInsets.all(
                                    SpaceComponent.staticHeight)
                                .copyWith(
                                    top: SpaceComponent.staticHeight -
                                        AddMemberOverviewComponent
                                            .removeMemberExtraSpace),
                            isHeightDynamic: true,
                            child: AddMemberOverviewComponent(
                              members: editMembers,
                              onRemoveMember: onRemoveMember,
                            ))),
                    SpaceColumnComponent(
                        child: ListItemIconTextComponent(
                            icon: IconEnum.add.icon, title: 'Invite Friend')),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: usersProvider.confirmedConnections.length +
                            1, // +1 for 'Connections' title
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SpaceColumnComponent(
                              heightMultiplier: 0.5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: ListItemContainerComponent
                                              .standardMargin +
                                          ListItemContainerComponent
                                              .standardPadding),
                                  child: Text(
                                    'Connections',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                            );
                          }

                          final user =
                              usersProvider.confirmedConnections[index - 1];
                          return SpaceColumnComponent(
                            child: ListItemUserComponent(
                              onTap: () => onTapUser(user),
                              user: user,
                              isSelected: editMembers
                                  .any((member) => member.id == user.id),
                            ),
                          );
                        })
                  ],
                ),
              ),
              cancelAndAcceptButton()
            ],
          ),
        ));
  }

  void onTapUser(UserModel tappedUser) {
    setState(() {
      if (editMembers.any((member) => member.id == tappedUser.id)) {
        editMembers.removeWhere((user) => user.id == tappedUser.id);
        return;
      }

      editMembers.add(tappedUser);
    });
  }

  onTapAccept() {
    widget.members.clear();
    widget.members.addAll(editMembers);
    Navigator.pop(context, editMembers);
  }

  onTapCancel() {
    Navigator.pop(context);
  }

  cancelAndAcceptButton() {
    return Row(
      children: [
        Expanded(
          child: ListItemButtonComponent(
            onTap: onTapCancel,
            text: 'Cancel',
            isMainButton: false,
            margin: const EdgeInsets.only(
                left: ListItemContainerComponent.standardMargin,
                right: ListItemContainerComponent.standardMargin / 2,
                bottom: BottomNavigationComponent.standardMargin),
          ),
        ),
        Expanded(
          child: ListItemButtonComponent(
              onTap: onTapAccept,
              text: 'Accept',
              isMainButton: true,
              margin: const EdgeInsets.only(
                  left: ListItemContainerComponent.standardMargin / 2,
                  right: ListItemContainerComponent.standardMargin,
                  bottom: BottomNavigationComponent.standardMargin)),
        ),
      ],
    );
  }

  onRemoveMember(String userId) {
    setState(() {
      editMembers.removeWhere((user) => user.id == userId);
    });
  }
}
