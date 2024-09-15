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
  final Set<UserModel> openConnectionRequests;

  const OpenRequestsPage({
    super.key,
    required this.preTitle,
    required this.openConnectionRequests,
  });

  @override
  State<OpenRequestsPage> createState() => _OpenRequestsPageState();
}

class _OpenRequestsPageState extends State<OpenRequestsPage> {
  String title = 'Open Requests';

  TextEditingController searchTextEditingController = TextEditingController();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late Set<UserModel> allConnections = widget.openConnectionRequests;
  Set<UserModel> openConnectionRequests = {};

  @override
  Widget build(BuildContext context) {
    allConnections = listeningUsersProvider.connections;
    openConnectionRequests = allConnections
        .where(
            (connection) => !connection.isConnectedWith(usersProvider.user.id))
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
      child: RefreshIndicator(
        color: themeColor1,
        onRefresh: () async {
          await usersProvider.getConnections();
        },
        child: ListView.builder(
          itemCount: openConnectionRequests.length,
          itemBuilder: (context, index) {
            UserModel connection = openConnectionRequests.elementAt(index);
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
          users: openConnectionRequests.toList(),
        ),
      ),
    );
  }
}
