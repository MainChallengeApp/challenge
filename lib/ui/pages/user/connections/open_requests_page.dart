import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
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
  final _searchTextEditingController = TextEditingController();

  final _scrollController = ScrollController();

  final _usersProvider = getIt<UsersProvider>();
  late UsersProvider _listeningUsersProvider;

  List<UserModel> _filteredOpenConnectionRequests = [];

  @override
  Widget build(BuildContext context) {
    _listeningUsersProvider = Provider.of<UsersProvider>(context);
    _filteredOpenConnectionRequests = _listeningUsersProvider
        .openConnectionRequests
        .where((connectionRequest) => connectionRequest.username
            .toLowerCase()
            .contains(_searchTextEditingController.text.toLowerCase()))
        .toList();

    return ScaffoldComponent(
      appBar: const AppBarComponent(
        title: 'Open Requests',
      ),
      body: Column(
        children: [_searchBar(), _connectionsList()],
      ),
    );
  }

  _searchBar() {
    return SpaceColumnComponent(
      child: ListItemSearchBarComponent(
        textEditingController: _searchTextEditingController,
        changeList: _changeList,
      ),
    );
  }

  _connectionsList() {
    return Expanded(
      child: RefreshIndicatorComponent(
        onRefresh: _onRefreshList,
        scrollController: _scrollController,
        child: ListView.builder(
          itemCount: _filteredOpenConnectionRequests.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemBuilder: (context, index) {
            UserModel connection =
                _filteredOpenConnectionRequests.elementAt(index);
            return SpaceColumnComponent(
              child: ListItemUserComponent(
                  onTap: () => _onTapConnection(connection), user: connection),
            );
          },
        ),
      ),
    );
  }

  _onTapConnection(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchUserPage(
          initUserId: user.id,
          getUsersList: () => _listeningUsersProvider.openConnectionRequests,
          searchText: _searchTextEditingController.text,
          isListPaginated: false,
        ),
      ),
    );
  }

  Future<void> _onRefreshList() async {
    await _scrollController.animateTo(-35,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut);
    _scrollController.animateTo(0,
        duration: const Duration(minutes: 1), curve: Curves.easeInOut);
    await _usersProvider.getConnections();
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  _changeList(String p1) {
    setState(() {});
  }
}
