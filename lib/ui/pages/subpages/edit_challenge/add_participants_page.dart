import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/edit_challenge/add_member_overview_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_invite_friends_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddParticipantsPage extends StatefulWidget {
  final List<UserModel> participants;

  const AddParticipantsPage({super.key, required this.participants});

  @override
  State<AddParticipantsPage> createState() => _AddParticipantsPageState();
}

class _AddParticipantsPageState extends State<AddParticipantsPage> {
  String title = 'Add Participants';

  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  final textEditingController = TextEditingController();

  late List<UserModel> editParticipants = List.from(widget.participants);

  final scrollController = ScrollController();

  late List<UserModel> filteredConnections =
      List.from(_usersProvider.confirmedConnections);

  @override
  void initState() {
    super.initState();
    _usersProvider.getConnections().then((_) {
      if (mounted) {
        setState(() {
          filteredConnections = List.from(_usersProvider.confirmedConnections);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ScaffoldComponent(
          appBar: AppBarComponent(title: title),
          isBottomNavigationVisible: false,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    searchBar(),
                    addParticipantsOverview(),
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
          await _usersProvider.getConnections().then((_) {
            setState(() {
              filteredConnections =
                  List.from(_usersProvider.confirmedConnections);
            });
          });
        },
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: 1 + // 1 + for Invite Friends button
                1 + // +1 for 'Connections' title
                filteredConnections.length +
                (filteredConnections
                        .isEmpty // +1 for 'No Connections' list item
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return inviteFriends();
              }

              int newIndex = index - 1; // -1 for 'Invite Friends' button

              return connectionsSearchList(newIndex);
            }),
      ),
    );
  }

  SpaceColumnComponent inviteFriends() {
    return SpaceColumnComponent(
        child: ListItemInviteFriendsComponent(
      username: _usersProvider.user.username,
    ));
  }

  SpaceColumnComponent addParticipantsOverview() {
    return SpaceColumnComponent(
        child: ListItemContainerComponent(
            padding: const EdgeInsets.all(SpaceComponent.standardHeight)
                .copyWith(
                    top: SpaceComponent.standardHeight -
                        AddMemberOverviewComponent.removeMemberExtraSpace),
            isHeightDynamic: true,
            child: AddMemberOverviewComponent(
              userId: _usersProvider.user.id,
              members: editParticipants,
              onRemoveMember: onRemoveParticipant,
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
      if (editParticipants
          .any((participant) => participant.id == tappedUser.id)) {
        editParticipants.removeWhere((user) => user.id == tappedUser.id);
        return;
      }
      if (editParticipants.length >= DatabaseService.maxGroupChallengeMember) {
        SnackBarComponent.showSnackBar(context,
            'You can only add up to ${DatabaseService.maxGroupChallengeMember} members');
        return;
      }
      editParticipants.add(tappedUser);
    });
  }

  onTapAccept() {
    widget.participants.clear();
    widget.participants.addAll(editParticipants);
    Navigator.pop(context, editParticipants);
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

  onRemoveParticipant(String userId) {
    setState(() {
      editParticipants.removeWhere((user) => user.id == userId);
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

    if (filteredConnections.isEmpty) {
      return const SpaceColumnComponent(
        child: ListItemInfoComponent(
          text: 'No Connections found',
        ),
      );
    }

    final user = filteredConnections[index - 1];
    return SpaceColumnComponent(
      child: ListItemUserComponent(
        onTap: () => onTapUser(user),
        user: user,
        isSelected:
            editParticipants.any((participant) => participant.id == user.id),
      ),
    );
  }

  changeList(String searchText) {
    setState(() {
      filteredConnections = _usersProvider.confirmedConnections.where((user) {
        return user.username.toLowerCase().startsWith(searchText.toLowerCase());
      }).toList();
    });
  }
}
