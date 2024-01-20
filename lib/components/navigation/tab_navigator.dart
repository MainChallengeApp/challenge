import 'package:flutter/material.dart';
import 'package:challenge/models/challenge.dart';
import 'package:challenge/enums/tab_item.enum.dart';

import 'no_animation_page_route.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {super.key, required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItemEnum tabItem;

  void ppush(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    var routeBuilders = prouteBuilders(context, challengeId: challengeId);

    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    return {
      TabNavigatorRoutes.root: (context) => Placeholder(),
      TabNavigatorRoutes.detail: (context) => Placeholder(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = prouteBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
