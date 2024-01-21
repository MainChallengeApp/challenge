import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge.page.dart';
import 'package:challenge/pages/home/home_list.page.dart';
import 'package:challenge/models/challenge.model.dart';
import 'package:challenge/components/navigation/tab_navigator.component.dart';

import 'package:challenge/components/navigation/no_animation_page_route.component.dart';

class HomeTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
  static const String addAcceptanceCriteria = '/addAcceptanceCriteria';
}

class HomeTabNavigator extends TabNavigatorComponent {
  const HomeTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

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
      HomeTabNavigatorRoutes.root: (context) => HomeListPage(
          title: tabItem.name, onPush: (c) => ppush(context, challenge: c)),
      // HomeTabNavigatorRoutes.detail: (context) => HomeChallenge(
      //       preTitle: tabItem.name,
      //       challenge: challenge!,
      //     ),
      HomeTabNavigatorRoutes.newChallenge: (context) => EditChallengePage(
            preTitle: tabItem.name,
            challenge: challenge!,
          ),
    };
  }
}
