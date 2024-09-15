import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
import 'package:challenge/ui/pages/user/connections/open_requests_page.dart';
import 'package:challenge/ui/pages/user/connections/open_responses_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionsPage extends StatefulWidget {
  final String preTitle;
  final Set<UserModel> connections;

  const ConnectionsPage({
    super.key,
    required this.preTitle,
    required this.connections,
  });

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  String title = 'Connections';

  TextEditingController searchTextEditingController = TextEditingController();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late Set<UserModel> allConnections = widget.connections;
  Set<UserModel> openConnectionRequests = {};
  Set<UserModel> confirmedConnections = {};
  Set<UserModel> openConnectionResponses = {};

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    allConnections = listeningUsersProvider.connections;
    openConnectionRequests = allConnections
        .where(
            (connection) => !connection.isConnectedWith(usersProvider.user.id))
        .toSet();
    confirmedConnections = allConnections
        .where(
            (connection) => connection.isConnectedWith(usersProvider.user.id))
        .toSet();

    return Scaffold(
      appBar: AppBarComponent(
        preTitle: widget.preTitle,
        titleText: title,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [searchBar(), connectionsList()],
      ),
    );
  }

  searchBar() {
    return SpaceColumnComponent(
      child: ListItemSearchBarComponent(
          textEditingController: searchTextEditingController),
    );
  }

  connectionsList() {
    return Expanded(
      child: RefreshIndicator.adaptive(
        color: themeColor1,
        displacement: 0,
        onRefresh: onRefreshList,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: confirmedConnections.length +
              1 +
              1, // +1 for openRequests +1 for openConnectionResponses
          itemBuilder: (context, index) {
            if (index == 0) {
              return openConnectionRequestsListItem();
            }

            if (index == 1) {
              return openConnectionResponsesListItem();
            }

            UserModel connection =
                confirmedConnections.elementAt(index - 1 - 1);
            return SpaceColumnComponent(
              child: ListItemUserComponent(
                  onTap: () => onTapConnection(connection),
                  user: connection,
                  onTapConnect: () {}),
            );
          },
        ),
      ),
    );
  }

  Future<void> onRefreshList() async {
    await scrollController.animateTo(-35,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut);
    scrollController.animateTo(0,
        duration: const Duration(minutes: 1), curve: Curves.easeInOut);
    await usersProvider.getConnections();
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  openConnectionRequestsListItem() {
    return Visibility(
      visible: openConnectionRequests.isNotEmpty,
      child: SpaceColumnComponent(
        child: ListItemIconTextTextComponent(
            icon: IconEnum.openRequests.icon,
            text: 'Open Requests',
            text2: openConnectionRequests.length.toString(),
            onTap: onTapOpenConnectionRequests),
      ),
    );
  }

  openConnectionResponsesListItem() {
    return Visibility(
      visible: openConnectionResponses.isNotEmpty,
      child: SpaceColumnComponent(
        child: ListItemIconTextTextComponent(
            icon: IconEnum.openResponses.icon,
            text: 'Open Requests',
            text2: openConnectionResponses.length.toString(),
            onTap: onTapOpenConnectionResponses),
      ),
    );
  }

  void onTapOpenConnectionRequests() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => OpenRequestsPage(
          preTitle: '${widget.preTitle}/$title',
          openConnectionRequests: openConnectionRequests,
        ),
      ),
    );
  }

  void onTapOpenConnectionResponses() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => OpenResponsesPage(
          preTitle: '${widget.preTitle}/$title',
          connections: openConnectionResponses,
        ),
      ),
    );
  }

  onTapConnection(UserModel user) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchUserPage(
          initUserId: user.id,
          preTitle: '${widget.preTitle}/$title',
          users: confirmedConnections.toList(),
        ),
      ),
    );
  }
}
