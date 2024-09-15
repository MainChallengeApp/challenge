import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';

class OpenResponsesPage extends StatefulWidget {
  final String preTitle;
  final Set<UserModel> connections;

  const OpenResponsesPage({
    super.key,
    required this.preTitle,
    required this.connections,
  });

  @override
  State<OpenResponsesPage> createState() => _OpenResponsesPageState();
}

class _OpenResponsesPageState extends State<OpenResponsesPage> {
  String title = 'Open Responses';

  TextEditingController searchTextEditingController = TextEditingController();

  // late final notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);
  // late final listeningNotificationsProvider =
  //     Provider.of<NotificationsProvider>(context, listen: true);

  Set<UserModel> openConnectionResponses = {};

  @override
  Widget build(BuildContext context) {
    // openConnectionResponses =

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
          // await notificationsProvider.getNotifications();
        },
        child: ListView.builder(
          itemCount: openConnectionResponses.length,
          itemBuilder: (context, index) {
            UserModel connection = openConnectionResponses.elementAt(index);
            return SpaceColumnComponent(
              child: ListItemUserComponent(
                  onTap: () {}, user: connection, onTapConnect: () {}),
            );
          },
        ),
      ),
    );
  }
}
