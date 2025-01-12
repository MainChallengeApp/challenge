import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/reports_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/search_challenge_card_component.dart';
import 'package:challenge/ui/components/cards/user_card_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchAllPage extends StatefulWidget {
  final int initialIndex;
  final String? searchText;
  final List<dynamic> Function() getList;
  final Function()? getPagination;
  final String title;

  const SearchAllPage(
      {super.key,
      this.initialIndex = 0,
      this.searchText,
      required this.getList,
      this.title = 'Search',
      this.getPagination});

  @override
  State<SearchAllPage> createState() => _SearchAllPageState();
}

class _SearchAllPageState extends State<SearchAllPage> {
  List<dynamic> get list => widget.getList();

  late PageController pageController =
      PageController(initialPage: widget.initialIndex);

  final mediaService = MediaService();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late final reportsProvider =
      Provider.of<ReportsProvider>(context, listen: false);

  bool isLoading = false;

  final panelController = PanelController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var entry in list) {
      if (entry is UserModel) {
        if (!entry.hasPicture() || mediaService.isUrlLocal(entry.pictureUrl!)) {
          continue;
        }
        precacheImage(NetworkImage(entry.pictureUrl!), context);
      } else if (entry is ChallengeModel) {
        if (!entry.hasThumbnail() ||
            mediaService.isUrlLocal(entry.thumbnail!.url)) {
          continue;
        }
        precacheImage(NetworkImage(entry.thumbnail!.url), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(
        title: widget.title,
      ),
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: list.map(
            (entry) {
              if (entry is UserModel) {
                return UserCardComponent(user: entry);
              } else if (entry is ChallengeModel) {
                return SearchChallengeCardComponent(challenge: entry);
              }
              return Container();
            },
          ).toList()),
    );
  }

  void onPageChanged(int value) {
    if (widget.getPagination != null &&
        value == usersProvider.searchUsers.length - 1) {
      widget.getPagination!();
    }
  }
}
