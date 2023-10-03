import 'package:flutter/widgets.dart';
import 'package:nested_navigation_demo_flutter/home_challenge.dart';
import 'package:nested_navigation_demo_flutter/home_list.dart';
import 'package:nested_navigation_demo_flutter/models/challenge.dart';
import 'package:nested_navigation_demo_flutter/tab_navigators/tab_navigator.dart';

class HomeTabNavigator extends TabNavigator {
  
  const HomeTabNavigator({super.key, required super.navigatorKey, required super.tabItem});

  @override
  void ppush(BuildContext context, {int challengeId = 0
  , Challenge? challenge
  }) {
    var routeBuilders = prouteBuilders(context, challenge: challenge!
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }
    @override
    Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    return {
      TabNavigatorRoutes.root: (context) => HomeList(
            title: tabItem.name,
            onPush: (c) =>
                ppush(context, challenge: c),
          ),
      TabNavigatorRoutes.detail: (context) => HomeChallenge(
            title: tabItem.name,
            challenge: challenge!,
          ),
    };
  }

}