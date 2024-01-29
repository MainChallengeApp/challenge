import 'package:challenge/pages/search/search_categories_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/components/navigation/tab_navigator_component.dart';

import 'package:challenge/components/navigation/no_animation_page_route_component.dart';

class SearchTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class SearchTabNavigator extends TabNavigatorComponent {
  const SearchTabNavigator(
      {super.key,
      required super.navigatorKey,
      required super.tabItem,
      required this.selectTab});

  final Function selectTab;

  @override
  void ppush(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    var routeBuilders = prouteBuilders(context, challenge: challenge!);

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  @override
  Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    return {
      SearchTabNavigatorRoutes.root: (context) => SearchCategoriesPage(
            title: tabItem.name,
            onPush: (c) => ppush(context, challenge: c),
            selectTab: selectTab,
          ),
      // SearchTabNavigatorRoutes.detail: (context) => SearchChallenge(
      //       title: tabItem.name,
      //       challenge: challenge!,
      //       selectTab: selectTab,
      //       challenges: const [],
      //     )
    };
  }
}
