import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/scroll_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/user_card_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  final String initUserId;
  final String? searchText;
  final bool isListPaginated;
  final List<UserModel> Function() getUsersList;
  final String title;

  const SearchUserPage(
      {super.key,
      required this.initUserId,
      this.searchText,
      this.isListPaginated = true,
      required this.getUsersList,
      this.title = 'Users'});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  List<UserModel> get _users => widget
      .getUsersList()
      .where((user) => user.searchInUser(widget.searchText ?? ''))
      .toList();

  late final PageController _pageController = PageController(
      initialPage: _users.indexWhere((user) => user.id == widget.initUserId));

  final _mediaService = MediaService();

  late final _usersProvider = getIt<UsersProvider>();

  @override
  void initState() {
    super.initState();
    ScrollService.fixOverScroll(_pageController, () => _users.length);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var user in _users) {
      if (!user.hasPicture() || _mediaService.isUrlLocal(user.pictureUrl!)) {
        continue;
      }
      precacheImage(NetworkImage(user.pictureUrl!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(
        title: widget.title,
      ),
      body: Center(
        child: PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            children: _users.map(
              (user) {
                return Builder(builder: (context) {
                  return UserCardComponent(user: user);
                });
              },
            ).toList()),
      ),
    );
  }

  void onPageChanged(int value) {
    if (!widget.isListPaginated ||
        value != _usersProvider.searchUsers.length - 1) {
      return;
    }
    _usersProvider.getSearchedPaginated(searchText: widget.searchText);
  }
}
