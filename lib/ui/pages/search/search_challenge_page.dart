import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/search_challenge_card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchChallengePage extends StatefulWidget {
  final int initChallengeIndex;
  final String searchText;
  final List<ChallengeCategoryEnum> categories;
  final bool isRandom;
  final String title;

  const SearchChallengePage(
      {super.key,
      required this.initChallengeIndex,
      required this.searchText,
      required this.categories,
      this.isRandom = false,
      this.title = 'Search'});

  @override
  State<SearchChallengePage> createState() => _SearchChallengePageState();
}

class _SearchChallengePageState extends State<SearchChallengePage> {
  late PageController pageController =
      PageController(initialPage: widget.initChallengeIndex);

  final mediaService = MediaService();

  late final searchChallengeProvider =
      Provider.of<SearchChallengesProvider>(context, listen: false);
  late final listeningSearchChallengeProvider =
      Provider.of<SearchChallengesProvider>(context);

  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    if (widget.isRandom) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      searchChallengeProvider.initRandomChallenges().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ErrorOccurredDialog.show(
              errorText: 'Error occurred during fetching shuffled challenges');
        }
      });
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var challenge in listeningSearchChallengeProvider.searchChallenges) {
      if (!challenge.hasThumbnail() ||
          mediaService.isUrlLocal(challenge.thumbnail!.url)) {
        continue;
      }
      precacheImage(NetworkImage(challenge.thumbnail!.url), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(title: widget.title),
      body: Center(
        child: _isLoading
            ? const LoadingCircleComponent()
            : listeningSearchChallengeProvider.searchChallenges.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      ListItemInfoComponent(text: 'No Challenges found'),
                    ],
                  )
                : PageView(
                    controller: pageController,
                    onPageChanged: onPageChanged,
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children:
                        listeningSearchChallengeProvider.searchChallenges.map(
                      (challenge) {
                        return SearchChallengeCardComponent(
                            challenge: challenge);
                      },
                    ).toList()),
      ),
    );
  }

  void onPageChanged(int value) {
    if (value != searchChallengeProvider.searchChallenges.length - 1) {
      return;
    }

    if (widget.isRandom) {
      searchChallengeProvider.getRandomPaginated();
      return;
    }
    searchChallengeProvider.getSearchedPaginated(
        searchText: widget.searchText, categories: widget.categories);
  }
}
