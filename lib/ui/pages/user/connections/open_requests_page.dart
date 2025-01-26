import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenRequestsPage extends StatefulWidget {
  const OpenRequestsPage({
    super.key,
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

  List<UserModel> filteredOpenConnectionRequests = [];

  @override
  Widget build(BuildContext context) {
    filteredOpenConnectionRequests = listeningUsersProvider
        .openConnectionRequests
        .where((connectionRequest) => connectionRequest.username
            .toLowerCase()
            .contains(searchTextEditingController.text.toLowerCase()))
        .toList();

    return ScaffoldComponent(
      appBar: AppBarComponent(
        title: title,
      ),
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
      child: RefreshIndicatorComponent(
        onRefresh: onRefreshList,
        scrollController: scrollController,
        child: ListView.builder(
          itemCount: filteredOpenConnectionRequests.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (context, index) {
            UserModel connection =
                filteredOpenConnectionRequests.elementAt(index);
            return SpaceColumnComponent(
              child: ListItemUserComponent(
                  onTap: () => onTapConnection(connection), user: connection),
            );
          },
        ),
      ),
    );
  }

  onTapConnection(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchUserPage(
          initUserId: user.id,
          getUsersList: () => listeningUsersProvider.openConnectionRequests,
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

  changeList(String p1) {
    setState(() {});
  }
}
