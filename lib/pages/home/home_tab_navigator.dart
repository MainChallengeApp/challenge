import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/components/navigation/tab_navigator_component.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/pages/home/home_list_page.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

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
  void push(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    var buildRoute = routeBuilders(context, challenge: challenge!);

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => buildRoute[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  @override
  Map<String, WidgetBuilder> routeBuilders(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    return {
      HomeTabNavigatorRoutes.root: (context) => HomeListPage(
          title: tabItem.name, onPush: (c) => push(context, challenge: c)),
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
