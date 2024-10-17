import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/challenge/title_with_percentage_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/search/search_description_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchChallengePage extends StatefulWidget {
  const SearchChallengePage(
      {super.key, required this.title, required this.initChallengeIndex});
  final String title;
  final int initChallengeIndex;

  @override
  State<SearchChallengePage> createState() => _SearchChallengePageState();
}

class _SearchChallengePageState extends State<SearchChallengePage> {
  bool isDescriptionExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initChallengeIndex);

  bool isKeyboardUp = false;

  late int currentChallengeIndex = widget.initChallengeIndex;

  final mediaService = MediaService();

  late final listeningSearchChallengeProvider =
      Provider.of<SearchChallengesProvider>(context);

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
      appBar: AppBarComponent(preTitle: widget.title),
      backgroundColor: Colors.white,
      body: Center(
        child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            scrollDirection: Axis.vertical,
            children: listeningSearchChallengeProvider.searchChallenges.map(
              (challenge) {
                return Builder(builder: (context) {
                  return CardComponent(
                    scrollPhysics: isKeyboardUp
                        ? const AlwaysScrollableScrollPhysics()
                        : listeningSearchChallengeProvider
                                    .searchChallenges.length ==
                                1
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                    children: [
                      thumbnail(challenge, context),
                      title(challenge),
                      description(challenge),
                      const SpaceComponent(),
                      selectButton(challenge)
                    ],
                  );
                });
              },
            ).toList()),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  selectButton(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : CustomButtonComponent(
            onTap: () => onTapSelect(challenge),
            isPrimaryButton: true,
            text: 'Select',
          );
  }

  thumbnail(ChallengeModel challenge, BuildContext context) {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
        challenge: challenge,
        isMediaListVisible: false,
        onTapOpenMediaPage: () => onTapOpenMediaPage(context),
      ),
    );
  }

  description(ChallengeModel challenge) {
    return Expanded(
      child: SearchDescriptionComponent(text: challenge.description),
    );
  }

  onTapOpenMediaPage(BuildContext context) {
    SnackBarComponent.showSnackBar(
        context, 'The Video Trailer will be added soon');
  }

  void onPageChanged(int value) {
    setState(() {
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      isDescriptionExpanded = false;
    });
  }

  void onTapSelect(ChallengeModel challenge) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: widget.title,
          challenge: challenge,
          isSearchEdit: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  title(ChallengeModel challenge) {
    return SpaceColumnComponent(
      height: 11,
      child: TitleWithPercentageComponent(
        challenge: challenge,
        isSearch: true,
      ),
    );
  }
}
