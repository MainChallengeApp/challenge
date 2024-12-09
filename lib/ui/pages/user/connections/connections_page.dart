import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_list_page.dart';
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

  late final tabProvider = Provider.of<TabProvider>(context, listen: false);

  List<UserModel> filteredConfirmedConnections = [];

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    usersProvider.getConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        preTitle: widget.preTitle,
        titleText: title,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [searchBar(), connectionsList()],
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
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
    filteredConfirmedConnections = listeningUsersProvider.confirmedConnections
        .where((connection) => connection.username
            .toLowerCase()
            .contains(searchTextEditingController.text.toLowerCase()))
        .toList();
    return Expanded(
      child: RefreshIndicatorComponent(
        onRefresh: onRefreshList,
        scrollController: scrollController,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: filteredConfirmedConnections.length +
              1 +
              1 +
              1, // +1 for openRequests +1 for openConnectionResponses
          itemBuilder: (context, index) {
            if (index == 0) {
              return SpaceColumnComponent(
                child: ListItemIconTextComponent(
                  icon: IconEnum.add.icon,
                  title: 'Add Connection',
                  onTap: onTapAddConnection,
                ),
              );
            }

            if (index == 1) {
              return openConnectionRequestsListItem();
            }

            if (index == 2) {
              return openConnectionResponsesListItem();
            }

            UserModel connection =
                filteredConfirmedConnections.elementAt(index - 1 - 1 - 1);
            return SpaceColumnComponent(
              child: ListItemUserComponent(
                  onTap: () => onTapUser(connection), user: connection),
            );
          },
        ),
      ),
    );
  }

  Future<void> onRefreshList() async {
    await usersProvider.getConnections();
  }

  openConnectionRequestsListItem() {
    return Visibility(
      visible: listeningUsersProvider.openConnectionRequests.isNotEmpty,
      child: SpaceColumnComponent(
        child: ListItemIconTextTextComponent(
            icon: IconEnum.openRequests.icon,
            text: 'Open Requests',
            text2:
                listeningUsersProvider.openConnectionRequests.length.toString(),
            onTap: onTapOpenConnectionRequests),
      ),
    );
  }

  openConnectionResponsesListItem() {
    return Visibility(
      visible: listeningUsersProvider.openConnectionResponses.isNotEmpty,
      child: SpaceColumnComponent(
        child: ListItemIconTextTextComponent(
            icon: IconEnum.openResponses.icon,
            text: 'Open Responses',
            text2: listeningUsersProvider.openConnectionResponses.length
                .toString(),
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

  onTapUser(UserModel user) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchUserPage(
          initUserId: user.id,
          preTitle: '${widget.preTitle}/$title',
          getUsersList: () => listeningUsersProvider.confirmedConnections,
          searchText: searchTextEditingController.text,
          isListPaginated: false,
        ),
      ),
    );
  }

  changeList(String p1) {
    setState(() {});
  }

  void onTapAddConnection() {
    var searchNavigator =
        tabProvider.navigatorKeys[TabItemEnum.search]!.currentState!;

    searchNavigator.popUntil((route) => route.isFirst);

    searchNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          preTitle: TabItemEnum.search.name,
          isUserSearchActive: true,
          initIsFilterOnChallenges: false,
          isSearchBarAutoFocus: true,
        ),
      ),
    );
    tabProvider.selectTab(TabItemEnum.search);
  }
}
