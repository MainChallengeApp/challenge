import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/edit_challenge/add_participants_overview_component.dart';
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

class EditParticipantsPage extends StatefulWidget {
  final List<UserModel> participants;

  const EditParticipantsPage({super.key, required this.participants});

  @override
  State<EditParticipantsPage> createState() => _EditParticipantsPageState();
}

class _EditParticipantsPageState extends State<EditParticipantsPage> {
  late final _usersProvider = getIt<UsersProvider>();

  final _textEditingController = TextEditingController();

  late final List<UserModel> _editParticipants = List.from(widget.participants);

  final _scrollController = ScrollController();

  late List<UserModel> _filteredConnections =
      List.from(_usersProvider.confirmedConnections);

  @override
  void initState() {
    super.initState();
    _usersProvider.getConnections().then((_) {
      if (mounted) {
        setState(() {
          _filteredConnections = List.from(_usersProvider.confirmedConnections);
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
          appBar: const AppBarComponent(title: 'Edit Participants'),
          isBottomNavigationVisible: false,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _searchBar(),
                    _addParticipantsOverview(),
                    _searchUsersList()
                  ],
                ),
              ),
              _cancelAndAcceptButton()
            ],
          ),
        ));
  }

  _searchUsersList() {
    return Expanded(
      child: RefreshIndicatorComponent(
        scrollController: _scrollController,
        onRefresh: () async {
          await _usersProvider.getConnections().then((_) {
            setState(() {
              _filteredConnections =
                  List.from(_usersProvider.confirmedConnections);
            });
          });
        },
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: 1 + // 1 + for Invite Friends button
                1 + // +1 for 'Connections' title
                _filteredConnections.length +
                (_filteredConnections
                        .isEmpty // +1 for 'No Connections' list item
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _inviteFriends();
              }

              int newIndex = index - 1; // -1 for 'Invite Friends' button

              return _connectionsSearchList(newIndex);
            }),
      ),
    );
  }

  SpaceColumnComponent _inviteFriends() {
    return SpaceColumnComponent(
        child: ListItemInviteFriendsComponent(
      username: _usersProvider.user.username,
    ));
  }

  SpaceColumnComponent _addParticipantsOverview() {
    return SpaceColumnComponent(
        child: ListItemContainerComponent(
            padding: const EdgeInsets.all(SpaceComponent.standardHeight)
                .copyWith(
                    top: SpaceComponent.standardHeight -
                        AddParticipantsOverviewComponent
                            .removeParticipantsExtraSpace),
            isHeightDynamic: true,
            child: AddParticipantsOverviewComponent(
              userId: _usersProvider.user.id,
              participants: _editParticipants,
              onRemoveParticipant: _onRemoveParticipant,
            )));
  }

  SpaceColumnComponent _searchBar() {
    return SpaceColumnComponent(
        child: ListItemSearchBarComponent(
      textEditingController: _textEditingController,
      changeList: _changeList,
    ));
  }

  void _onTapUser(UserModel tappedUser) {
    setState(() {
      if (_editParticipants
          .any((participant) => participant.id == tappedUser.id)) {
        _editParticipants.removeWhere((user) => user.id == tappedUser.id);
        return;
      }
      if (_editParticipants.length >= DatabaseService.maxGroupChallengeMember) {
        SnackBarComponent.showSnackBar(
            'You can only add up to ${DatabaseService.maxGroupChallengeMember} members');
        return;
      }
      _editParticipants.add(tappedUser);
    });
  }

  _onTapAccept() {
    widget.participants.clear();
    widget.participants.addAll(_editParticipants);
    Navigator.pop(context, _editParticipants);
  }

  _onTapCancel() {
    Navigator.pop(context);
  }

  _cancelAndAcceptButton() {
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
              onTap: _onTapCancel,
              text: 'Cancel',
              isMainButton: false,
              margin: const EdgeInsets.only(
                right: ListItemContainerComponent.standardMargin / 2,
              ),
            ),
          ),
          Expanded(
            child: ListItemButtonComponent(
                onTap: _onTapAccept,
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

  _onRemoveParticipant(String userId) {
    setState(() {
      _editParticipants.removeWhere((user) => user.id == userId);
    });
  }

  _listSubTitle(String title) {
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

  _connectionsSearchList(int index) {
    if (index == 0) {
      return _listSubTitle('Connections');
    }

    if (_filteredConnections.isEmpty) {
      return const SpaceColumnComponent(
        child: ListItemInfoComponent(
          text: 'Connect to uses to add them to your challenge',
        ),
      );
    }

    final user = _filteredConnections[index - 1];
    return SpaceColumnComponent(
      child: ListItemUserComponent(
        onTap: () => _onTapUser(user),
        user: user,
        isSelected:
            _editParticipants.any((participant) => participant.id == user.id),
      ),
    );
  }

  _changeList(String searchText) {
    setState(() {
      _filteredConnections = _usersProvider.confirmedConnections.where((user) {
        return user.username.toLowerCase().startsWith(searchText.toLowerCase());
      }).toList();
    });
  }
}
