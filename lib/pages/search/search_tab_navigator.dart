import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/models/challenge.dart';
import 'package:challenge/pages/search/search_list.dart';
import 'package:challenge/components/navigation/tab_navigator.dart';

import 'package:challenge/components/navigation/no_animation_page_route.dart';

class SearchTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class SearchTabNavigator extends TabNavigator {
  const SearchTabNavigator(
      {super.key,
      required super.navigatorKey,
      required super.tabItem,
      required this.selectTab});

  final Function selectTab;

  @override
  void ppush(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    var routeBuilders = prouteBuilders(context, challenge: challenge!);

    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  @override
  Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    return {
      SearchTabNavigatorRoutes.root: (context) => SearchList(
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
