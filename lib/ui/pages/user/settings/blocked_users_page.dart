import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});
  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final _usersProvider = getIt<UsersProvider>();
  late UsersProvider _listeningUsersProvider;

  final _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _usersProvider.getBlockedUser();
  }

  @override
  Widget build(BuildContext context) {
    _listeningUsersProvider = Provider.of<UsersProvider>(context);
    return ScaffoldComponent(
      appBar: const AppBarComponent(title: 'Blocked Users'),
      body: RefreshIndicatorComponent(
        onRefresh: () async {
          await _usersProvider.getBlockedUser();
        },
        scrollController: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _listeningUsersProvider.blockedUsers.length +
              1, // +1 for add blocked user
          itemBuilder: (context, index) {
            if (index == 0) {
              return const SpaceColumnComponent(
                child: ListItemInfoComponent(
                  text: 'You do not have any blocked users',
                ),
              );
            }

            UserModel user = _listeningUsersProvider.blockedUsers[index - 1];
            return SpaceColumnComponent(
                child: ListItemUserComponent(
              onTap: () => _onTapUser(user),
              user: user,
            ));
          },
        ),
      ),
    );
  }

  _onTapUser(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchUserPage(
          getUsersList: () => _listeningUsersProvider.blockedUsers,
          initUserId: user.id,
        ),
      ),
    );
  }
}
