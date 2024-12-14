import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/search/search_description_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
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
              context: context,
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarComponent(title: widget.title),
      backgroundColor: Colors.white,
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
                        return Builder(builder: (context) {
                          return CardComponent(
                            children: [
                              _thumbnail(challenge, context),
                              _title(challenge),
                              _description(challenge),
                              const SpaceComponent(),
                              _selectButton(challenge)
                            ],
                          );
                        });
                      },
                    ).toList()),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  _selectButton(ChallengeModel challenge) {
    return CustomButtonComponent(
      onTap: () => onTapSelect(challenge),
      isPrimaryButton: true,
      text: 'Select',
    );
  }

  _thumbnail(ChallengeModel challenge, BuildContext context) {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
        challenge: challenge,
        onTapOpenMediaPage: () => onTapOpenMediaPage(context),
      ),
    );
  }

  _description(ChallengeModel challenge) {
    return Expanded(
      child: SearchDescriptionComponent(text: challenge.description),
    );
  }

  onTapOpenMediaPage(BuildContext context) {
    SnackBarComponent.showSnackBar(
        context, 'The Video Trailer will be added soon');
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

  void onTapSelect(ChallengeModel challenge) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          challenge: challenge,
          isSearchEdit: true,
          isNewChallenge: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  _title(ChallengeModel challenge) {
    return SpaceColumnComponent(
      height: 11,
      child: TitleComponent(
        title: challenge.title,
      ),
    );
  }
}
