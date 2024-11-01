import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/edit_challenge/add_member_overview_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
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

  final scrollController = ScrollController();

  late List<UserModel> filteredConnections =
      List.from(usersProvider.confirmedConnections);

  @override
  void initState() {
    super.initState();
    usersProvider.initSearchUsers().then((_) {
      setState(() {
        filteredConnections = List.from(usersProvider.confirmedConnections);
      });
    });
    usersProvider.getConnections();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        usersProvider.getSearchedPaginated(
            searchText: textEditingController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    searchBar(),
                    addMemberOverview(),
                    searchUsersList()
                  ],
                ),
              ),
              cancelAndAcceptButton()
            ],
          ),
        ));
  }

  searchUsersList() {
    return Expanded(
      child: RefreshIndicatorComponent(
        scrollController: scrollController,
        onRefresh: () async {
          await usersProvider
              .initSearchUsers(searchText: textEditingController.text)
              .then((_) {
            setState(() {
              filteredConnections =
                  List.from(usersProvider.confirmedConnections);
            });
          });
          await usersProvider.getConnections();
        },
        child: ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: 1 + // 1 + for Invite Friends button
                filteredConnections.length +
                1 +
                usersProvider.searchUsers.length +
                1 +
                1, // +1 for 'Connections' title and +1 for 'Other Users' title +1 for 'Invite Friends' button and loading circle
            itemBuilder: (context, index) {
              if (index == 0) {
                return inviteFriends();
              }

              int newIndex = index - 1; // -1 for 'Invite Friends' button

              if (filteredConnections.isNotEmpty &&
                  newIndex < filteredConnections.length + 1) {
                // +1 for 'Connections' title
                return connectionsSearchList(newIndex);
              }
              return allUsersSearchList(newIndex);
            }),
      ),
    );
  }

  SpaceColumnComponent inviteFriends() {
    return SpaceColumnComponent(
        child: ListItemIconTextComponent(
            icon: IconEnum.add.icon, title: 'Invite Friends', onTap: () {}));
  }

  SpaceColumnComponent addMemberOverview() {
    return SpaceColumnComponent(
        child: ListItemContainerComponent(
            padding: const EdgeInsets.all(SpaceComponent.staticHeight).copyWith(
                top: SpaceComponent.staticHeight -
                    AddMemberOverviewComponent.removeMemberExtraSpace),
            isHeightDynamic: true,
            child: AddMemberOverviewComponent(
              members: editMembers,
              onRemoveMember: onRemoveMember,
            )));
  }

  SpaceColumnComponent searchBar() {
    return SpaceColumnComponent(
        child: ListItemSearchBarComponent(
      textEditingController: textEditingController,
      changeList: changeList,
    ));
  }

  void onTapUser(UserModel tappedUser) {
    setState(() {
      if (editMembers.any((member) => member.id == tappedUser.id)) {
        editMembers.removeWhere((user) => user.id == tappedUser.id);
        return;
      }
      if (editMembers.length >= DatabaseService.maxGroupChallengeMember) {
        SnackBarComponent.showSnackBar(context,
            'You can only add up to ${DatabaseService.maxGroupChallengeMember} members');
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
    return Padding(
      padding: const EdgeInsets.only(
          left: ListItemContainerComponent.standardMargin,
          right: ListItemContainerComponent.standardMargin,
          bottom: BottomNavigationComponent.standardMargin,
          top: BottomNavigationComponent.standardMargin),
      child: Row(
        children: [
          Expanded(
            child: ListItemButtonComponent(
              onTap: onTapCancel,
              text: 'Cancel',
              isMainButton: false,
              margin: const EdgeInsets.only(
                right: ListItemContainerComponent.standardMargin / 2,
              ),
            ),
          ),
          Expanded(
            child: ListItemButtonComponent(
                onTap: onTapAccept,
                text: 'Accept',
                isMainButton: true,
                margin: const EdgeInsets.only(
                  left: ListItemContainerComponent.standardMargin / 2,
                )),
          ),
        ],
      ),
    );
  }

  onRemoveMember(String userId) {
    setState(() {
      editMembers.removeWhere((user) => user.id == userId);
    });
  }

  listSubTitle(String title) {
    return SpaceColumnComponent(
      heightMultiplier: 0.5,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(
              left: ListItemContainerComponent.standardMargin +
                  ListItemContainerComponent.standardPadding),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  connectionsSearchList(int index) {
    if (index == 0) {
      return listSubTitle('Connections');
    }

    final user = filteredConnections[index - 1];
    return SpaceColumnComponent(
      child: ListItemUserComponent(
        onTap: () => onTapUser(user),
        user: user,
        isSelected: editMembers.any((member) => member.id == user.id),
      ),
    );
  }

  allUsersSearchList(int index) {
    int newIndex =
        index - filteredConnections.length - 1; // -1 for 'Connections' title
    if (newIndex == 0) {
      return listSubTitle('All Users');
    }

    if (newIndex == usersProvider.searchUsers.length + 1) {
      return usersProvider.isEndOfSearchedListReached
          ? inviteFriends()
          : const Center(
              child: SpaceColumnComponent(child: LoadingCircleComponent()),
            );
    }

    final user =
        usersProvider.searchUsers[newIndex - 1]; // -1 for 'All Users' title
    return SpaceColumnComponent(
      child: ListItemUserComponent(
        onTap: () => onTapUser(user),
        user: user,
        isSelected: editMembers.any((member) => member.id == user.id),
      ),
    );
  }

  changeList(String searchText) {
    usersProvider.initSearchUsers(searchText: searchText);
    filteredConnections = usersProvider.confirmedConnections.where((user) {
      return user.username.toLowerCase().startsWith(searchText.toLowerCase());
    }).toList();
  }
}
