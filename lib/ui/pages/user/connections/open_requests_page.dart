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

class OpenRequestsPage extends StatefulWidget {
  final String preTitle;

  const OpenRequestsPage({
    super.key,
    required this.preTitle,
  });

  @override
  State<OpenRequestsPage> createState() => _OpenRequestsPageState();
}

class _OpenRequestsPageState extends State<OpenRequestsPage> {
  String title = 'Open Requests';

  TextEditingController searchTextEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  List<UserModel> openConnectionRequests = [];
  List<UserModel> filteredOpenConnectionRequests = [];

  @override
  Widget build(BuildContext context) {
    openConnectionRequests = listeningUsersProvider.outgoingConnections
        .where(
            (connection) => !connection.isConnectedWith(usersProvider.user.id))
        .toList();
    filteredOpenConnectionRequests = openConnectionRequests
        .where((connectionRequest) => connectionRequest.username
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
    return Expanded(
      child: RefreshIndicator.adaptive(
        color: themeColor1,
        displacement: 0,
        onRefresh: onRefreshList,
        child: ListView.builder(
          itemCount: filteredOpenConnectionRequests.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (context, index) {
            UserModel connection =
                filteredOpenConnectionRequests.elementAt(index);
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
          users: filteredOpenConnectionRequests,
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

  changeList(String p1) {
    setState(() {});
  }
}
