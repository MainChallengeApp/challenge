import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key, required this.preTitle});

  final String preTitle;

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  String title = 'Blocked Users';

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider = Provider.of<UsersProvider>(context);

  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    usersProvider.getBlockedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
      backgroundColor: Colors.white,
      body: RefreshIndicatorComponent(
        onRefresh: () async {
          await usersProvider.getBlockedUser();
        },
        scrollController: scrollController,
        child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: listeningUsersProvider.blockedUsers.length +
              1, // +1 for add blocked user
          itemBuilder: (context, index) {
            if (index == 0) {
              return SpaceColumnComponent(
                child: ListItemIconTextComponent(
                  icon: IconEnum.info.icon,
                  title: 'You do not have any blocked users',
                ),
              );
            }

            UserModel user = listeningUsersProvider.blockedUsers[index - 1];
            return SpaceColumnComponent(
                child: ListItemUserComponent(
              onTap: () => onTapUser(user),
              user: user,
            ));
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  onTapUser(UserModel user) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchUserPage(
          preTitle: '${widget.preTitle}/$title',
          getUsersList: () => listeningUsersProvider.blockedUsers,
          initUserId: user.id,
        ),
      ),
    );
  }
}
