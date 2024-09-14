import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionsPage extends StatefulWidget {
  final String preTitle;
  final Set<String> connectionIds;

  const ConnectionsPage(
      {super.key, required this.preTitle, required this.connectionIds});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  String title = 'Connections';

  TextEditingController searchTextEditingController = TextEditingController();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  Set<UserModel> connections = {};

  @override
  void initState() {
    super.initState();
    fetchConnections();
  }

  @override
  Widget build(BuildContext context) {
    connections = listeningUsersProvider.connections;
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
      child: ListView.builder(
        itemCount: connections.length,
        itemBuilder: (context, index) {
          UserModel connection = connections.elementAt(index);
          return SpaceColumnComponent(
            child: ListItemUserComponent(
                onTap: () {}, user: connection, onTapConnect: () {}),
          );
        },
      ),
    );
  }

  void fetchConnections() {
    usersProvider.getConnections();
  }
}
