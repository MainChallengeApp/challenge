import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/edit_challenge/add_member_overview_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
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
              SpaceColumnComponent(
                  child: ListItemSearchBarComponent(
                      textEditingController: textEditingController)),
              SpaceColumnComponent(
                  child: ListItemContainerComponent(
                      padding:
                          const EdgeInsets.all(SpaceComponent.staticHeight),
                      isHeightDynamic: true,
                      child:
                          AddMemberOverviewComponent(members: widget.members))),
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
                                    ListItemContainerComponent.standardPadding),
                            child: Text(
                              'Connections',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    }

                    final user = usersProvider.confirmedConnections[index - 1];
                    return SpaceColumnComponent(
                      child: ListItemUserComponent(
                        onTap: () => onTapUser(user),
                        user: user,
                        isSelected: widget.members
                            .any((member) => member.id == user.id),
                      ),
                    );
                  })
            ],
          ),
        ));
  }

  void onTapUser(UserModel tappedUser) {
    setState(() {
      if (widget.members.any((member) => member.id == tappedUser.id)) {
        widget.members.removeWhere((user) => user.id == tappedUser.id);
        return;
      }

      widget.members.add(tappedUser);
    });
  }
}
