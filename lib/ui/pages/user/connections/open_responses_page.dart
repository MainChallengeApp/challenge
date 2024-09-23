import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
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

  @override
  Widget build(BuildContext context) {
    openConnectionResponses = listeningUsersProvider.incomingConnections
        .where(
            (connection) => !usersProvider.user.isConnectedWith(connection.id))
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
          itemCount: openConnectionResponses.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (context, index) {
            UserModel connection = openConnectionResponses.elementAt(index);
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
          users: openConnectionResponses.toList(),
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
