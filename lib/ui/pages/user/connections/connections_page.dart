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

  const ConnectionsPage({
    super.key,
    required this.preTitle,
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

  List<UserModel> openConnectionRequests = [];
  List<UserModel> openConnectionResponses = [];
  List<UserModel> confirmedConnections = [];
  List<UserModel> filteredConfirmedConnections = [];

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    openConnectionRequests = listeningUsersProvider.outgoingConnections
        .where(
            (connection) => !connection.isConnectedWith(usersProvider.user.id))
        .toList();
    openConnectionResponses = listeningUsersProvider.incomingConnections
        .where(
            (connection) => !usersProvider.user.isConnectedWith(connection.id))
        .toList();
    confirmedConnections = listeningUsersProvider.outgoingConnections
        .where(
            (connection) => connection.isConnectedWith(usersProvider.user.id))
        .toList();

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
        textEditingController: searchTextEditingController,
        changeList: changeList,
      ),
    );
  }

  connectionsList() {
    filteredConfirmedConnections = confirmedConnections
        .where((connection) => connection.username
            .toLowerCase()
            .contains(searchTextEditingController.text.toLowerCase()))
        .toList();
    return Expanded(
      child: RefreshIndicator.adaptive(
        color: themeColor1,
        displacement: 0,
        onRefresh: onRefreshList,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: filteredConfirmedConnections.length +
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
                filteredConfirmedConnections.elementAt(index - 1 - 1);
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
            text: 'Open Responses',
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
          users: filteredConfirmedConnections,
        ),
      ),
    );
  }

  changeList(String p1) {
    setState(() {});
  }
}
