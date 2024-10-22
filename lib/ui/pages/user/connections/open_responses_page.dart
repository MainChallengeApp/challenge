import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenResponsesPage extends StatefulWidget {
  final String preTitle;

  const OpenResponsesPage({
    super.key,
    required this.preTitle,
  });

  @override
  State<OpenResponsesPage> createState() => _OpenResponsesPageState();
}

class _OpenResponsesPageState extends State<OpenResponsesPage> {
  String title = 'Open Responses';

  TextEditingController searchTextEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  List<UserModel> openConnectionResponses = [];
  List<UserModel> filteredOpenConnectionResponses = [];

  @override
  Widget build(BuildContext context) {
    openConnectionResponses = listeningUsersProvider.incomingConnections
        .where(
            (connection) => !usersProvider.user.isConnectedWith(connection.id))
        .toList();
    filteredOpenConnectionResponses = openConnectionResponses
        .where((connection) => connection.username
            .toLowerCase()
            .contains(searchTextEditingController.text.toLowerCase()))
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
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  searchBar() {
    return SpaceColumnComponent(
      child: ListItemSearchBarComponent(
        textEditingController: searchTextEditingController,
        changeList: (_) => setState(() {}),
      ),
    );
  }

  connectionsList() {
    return Expanded(
      child: RefreshIndicatorComponent(
        onRefresh: onRefreshList,
        scrollController: scrollController,
        child: ListView.builder(
          itemCount: filteredOpenConnectionResponses.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (context, index) {
            UserModel connection =
                filteredOpenConnectionResponses.elementAt(index);
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

  onTapConnection(UserModel user) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchUserPage(
          initUserId: user.id,
          preTitle: '${widget.preTitle}/$title',
          users: filteredOpenConnectionResponses,
          searchText: searchTextEditingController.text,
          isListPaginated: false,
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
}
