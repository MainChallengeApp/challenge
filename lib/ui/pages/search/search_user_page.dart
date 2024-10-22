import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
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

class SearchUserPage extends StatefulWidget {
  final String preTitle;
  final List<UserModel> users;
  final String initUserId;
  final String searchText;
  final bool isListPaginated;

  const SearchUserPage(
      {super.key,
      required this.preTitle,
      required this.users,
      required this.initUserId,
      required this.searchText,
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
    return Scaffold(
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
                      connect(user)
                    ],
                  );
                });
              },
            ).toList()),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
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
    return listeningUsersProvider.user.outgoingConnectionIds.contains(user.id)
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
            child: Center(
              child: Icon(
                Icons.more_horiz_rounded,
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
}
