import 'dart:math';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/components/user/bio_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchUserPage extends StatefulWidget {
  final String preTitle;
  final List<UserModel> users;
  final String initUserId;
  final String? searchText;
  final bool isListPaginated;

  const SearchUserPage(
      {super.key,
      required this.preTitle,
      required this.users,
      required this.initUserId,
      this.searchText,
      this.isListPaginated = true});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  bool isBioExpanded = false;
  late PageController pageController = PageController(
      initialPage:
          widget.users.indexWhere((user) => user.id == widget.initUserId));

  bool isKeyboardUp = false;

  final mediaService = MediaService();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider = Provider.of<UsersProvider>(context);

  bool isLoading = false;

  final panelController = PanelController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var user in widget.users) {
      if (!user.hasPicture() || mediaService.isUrlLocal(user.pictureUrl!)) {
        continue;
      }
      precacheImage(NetworkImage(user.pictureUrl!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.3,
      backdropEnabled: true,
      panel: panel(),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      padding: const EdgeInsets.only(top: 10),
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarComponent(preTitle: widget.preTitle),
        backgroundColor: Colors.white,
        body: Center(
          child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.vertical,
              children: widget.users.map(
                (user) {
                  return Builder(builder: (context) {
                    return CardComponent(
                      scrollPhysics: isKeyboardUp
                          ? const AlwaysScrollableScrollPhysics()
                          : widget.users.length == 1
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                      children: [
                        profilePicture(user),
                        usernameAndMore(user),
                        bio(user),
                        challengesAndConnections(user),
                        expandedSpace(),
                        actionButton(user)
                      ],
                    );
                  });
                },
              ).toList()),
        ),
        bottomNavigationBar: const BottomNavigationComponent(),
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      isBioExpanded = false;
    });
    if (!widget.isListPaginated ||
        value != usersProvider.searchUsers.length - 1) {
      return;
    }
    usersProvider.getSearchedPaginated(searchText: widget.searchText);
  }

  bio(UserModel user) {
    BioComponent bioComponent = BioComponent(
      bio: user.bio,
      onTap: () {
        setState(() {
          isBioExpanded = !isBioExpanded;
        });
      },
      isBioExpanded: isBioExpanded,
    );
    return isBioExpanded
        ? Expanded(
            child: Column(
              children: [
                Expanded(child: bioComponent),
                const SpaceComponent(),
              ],
            ),
          )
        : user.bio != null && user.bio!.isNotEmpty
            ? SpaceColumnComponent(
                child: bioComponent,
              )
            : Container();
  }

  challengesAndConnections(UserModel user) {
    return Visibility(
      visible: !isBioExpanded,
      child: SpaceColumnComponent(
        child: Row(
          children: [
            Expanded(
              child: TapContainerComponent(
                onTap: () {},
                child: const Column(
                  children: [
                    Text(
                      '-',
                    ),
                    Text(
                      'Challenges',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            const SpaceComponent(),
            Expanded(
              child: TapContainerComponent(
                onTap: () {},
                child: const Column(
                  children: [
                    Text(
                      '-',
                    ),
                    Text(
                      'Connections',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  connect(UserModel user) {
    return listeningUsersProvider.outgoingConnections
            .map((user) => user.id)
            .contains(user.id)
        ? CustomButtonComponent(
            onTap: () => onTapDisconnect(user.id),
            isPrimaryButton: false,
            isLoading: isLoading,
            text: user.isConnectedWith(usersProvider.user.id)
                ? 'Disconnect'
                : 'Cancel Request',
          )
        : CustomButtonComponent(
            onTap: () => onTapConnect(user.id),
            isLoading: isLoading,
            isPrimaryButton: true,
            text: 'Connect',
          );
  }

  userName(UserModel user) {
    return SpaceColumnComponent(
      height: 11,
      child: TitleComponent(title: '@${user.username}'),
    );
  }

  expandedSpace() {
    return isBioExpanded ? Container() : Expanded(child: Container());
  }

  usernameAndMore(UserModel user) {
    return SpaceColumnComponent(
      child: Row(
        children: [
          Expanded(
              child: TapContainerComponent(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '@${user.username}',
                        overflow: TextOverflow.ellipsis,
                      )))),
          const SpaceComponent(),
          TapContainerComponent(
            isQuadratic: true,
            onTap: onTapMore,
            child: Center(
              child: Icon(
                IconEnum.more.icon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          )
        ],
      ),
    );
  }

  onTapConnect(String userId) async {
    setState(() {
      isLoading = true;
    });
    await usersProvider.connectToUser(userId);
    setState(() {
      isLoading = false;
    });
  }

  onTapDisconnect(String id) async {
    setState(() {
      isLoading = true;
    });
    await usersProvider.disconnectFromUser(id);
    setState(() {
      isLoading = false;
    });
  }

  profilePicture(UserModel user) {
    return SpaceColumnComponent(
      child: UserPictureMinComponent(
        userPictureUrl: user.pictureUrl,
        size: 100,
      ),
    );
  }

  onTapMore() {
    panelController.open();
  }

  panel() {
    if (widget.users.isEmpty) {
      return;
    }
    String userId = pageController.hasClients
        ? widget
            .users[min(pageController.page!.round(), widget.users.length - 1)]
            .id
        : widget.initUserId;
    return Column(
      children: [
        const SpaceComponent(
          height: 5,
        ),
        SpaceColumnComponent(
          child: Center(
              child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.all(Radius.circular(24))),
          )),
        ),
        SpaceColumnComponent(
            child: usersProvider.user.isBlocked(userId)
                ? ListItemIconTextComponent(
                    icon: IconEnum.blockedUsers.icon,
                    title: 'Unblock User',
                    onTap: () => onTapUnblock(userId))
                : ListItemIconTextComponent(
                    icon: IconEnum.blockedUsers.icon,
                    title: 'Block User',
                    onTap: () => onTapBlockUser(userId))),
        SpaceColumnComponent(
            child: ListItemIconTextComponent(
                icon: IconEnum.reportUser.icon, title: 'Report User')),
      ],
    );
  }

  void onTapBlockUser(String userId) {
    panelController.close();
    usersProvider.blockUser(userId);
  }

  Future<void> onTapUnblock(String userId) async {
    setState(() {
      isLoading = true;
    });
    await usersProvider.unblockUser(userId);
    if (widget.users.isEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  actionButton(UserModel user) {
    return usersProvider.user.isBlocked(user.id)
        ? unblock(user)
        : connect(user);
  }

  unblock(UserModel user) {
    return CustomButtonComponent(
      onTap: () => onTapUnblock(user.id),
      isPrimaryButton: true,
      isLoading: isLoading,
      text: 'Unblock',
    );
  }
}
