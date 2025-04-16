import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/dialogs/delete_challenge_dialog.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key, required this.title});
  final String title;

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  late final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  late final _listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context);

  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);
  final _tabProvider = getIt<TabProvider>();

  List<GroupChallengeModel> _filteredChallenges = [];

  final ScrollController _scrollController = ScrollController();

  final _searchTextEditingController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _groupChallengesProvider.getAllOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScaffoldComponent(
        appBar: AppBarComponent(
          title: widget.title,
          isFirstPageInRoute: true,
        ),
        body: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    _mergeAndSortChallenges();

    return Column(
      children: [
        _searchBar(),
        Expanded(
          child: RefreshIndicatorComponent(
            scrollController: _scrollController,
            onRefresh: () async {
              await _groupChallengesProvider.getAllOfUser();
            },
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _filteredChallenges.length +
                      1, // +1 for new Challenge listItem
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return _newChallenge();
                    }
                    GroupChallengeModel groupChallenge = _filteredChallenges[
                        index - 1]; // -1 for new Challenge listItem

                    groupChallenge.checkStatus();
                    return SpaceColumnComponent(
                      child: ListItemChallengeSmallComponent(
                        onTap: () => _onTapChallenge(context,
                            challenge: groupChallenge, index: index - 1),
                        challenge: groupChallenge,
                        participant: groupChallenge
                            .getParticipant(_usersProvider.user.id),
                        attempt: groupChallenge
                            .getParticipant(_usersProvider.user.id)
                            .getLatestAttempt(),
                        onTapDeleteChallenge: () =>
                            _onTapDeleteChallenge(groupChallenge),
                        onTapEditChallenge: () =>
                            _onTapEditChallenge(groupChallenge),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  void _mergeAndSortChallenges() {
    _filteredChallenges.clear();
    _filteredChallenges
        .addAll(_listeningGroupChallengesProvider.groupChallenges);
    _filteredChallenges = _filteredChallenges
        .where((element) =>
            element
                .searchInChallenge(_searchTextEditingController.text.trim()) &&
            element.getParticipant(_usersProvider.user.id).isAccepted())
        .toList();
    _filteredChallenges = GroupChallengeModel.sortChallengeList(
        groupChallenges: _filteredChallenges, userId: _usersProvider.user.id);
  }

  SpaceColumnComponent _newChallenge() {
    return SpaceColumnComponent(
      child: ListItemIconTextComponent(
        onTap: () => _tapOnNewChallenge(),
        icon: IconEnum.add.icon,
        title: 'New Challenge',
      ),
    );
  }

  SpaceColumnComponent _searchBar() {
    return SpaceColumnComponent(
      child: ListItemSearchBarComponent(
        changeList: (_) => setState(() {}),
        textEditingController: _searchTextEditingController,
        hintText: 'Search in your Challenges',
      ),
    );
  }

  void _onTapChallenge(BuildContext context,
      {required ChallengeModel challenge, required int index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeChallengePage(
          initialChallengeId: challenge.id,
          filterOptions: _searchTextEditingController.text.trim(),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  _tapOnNewChallenge() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChallengePage(
          challenge: ChallengeModel.empty(),
          isNewChallenge: true,
        ),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onTapDeleteChallenge(GroupChallengeModel groupChallenge) {
    DeleteChallengeDialog.show(
      context: context,
      challengeTitle: groupChallenge.title,
      onTapYes: () async {
        await _groupChallengesProvider.deleteParticipant(groupChallenge);
      },
    );
  }

  _onTapEditChallenge(GroupChallengeModel groupChallenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChallengePage(
          challenge: groupChallenge,
          isNewChallenge: false,
        ),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
