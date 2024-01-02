import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge.dart';
import 'package:challenge/pages/home/home_list.dart';
import 'package:challenge/models/challenge.dart';
import 'package:challenge/components/navigation/tab_navigator.dart';

import '../../components/navigation/no_animation_page_route.dart';

class HomeTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
  static const String addAcceptanceCriteria = '/addAcceptanceCriteria';
}

class HomeTabNavigator extends TabNavigator {
  const HomeTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

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
      HomeTabNavigatorRoutes.root: (context) => HomeList(
          title: tabItem.name, onPush: (c) => ppush(context, challenge: c)),
      // HomeTabNavigatorRoutes.detail: (context) => HomeChallenge(
      //       preTitle: tabItem.name,
      //       challenge: challenge!,
      //     ),
      HomeTabNavigatorRoutes.newChallenge: (context) => EditChallenge(
            preTitle: tabItem.name,
            challenge: challenge!,
          ),
    };
  }
}
