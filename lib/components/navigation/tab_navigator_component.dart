import 'package:flutter/material.dart';
import 'package:challenge/enums/tab_item_enum.dart';

import 'no_animation_page_route_component.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigatorComponent extends StatelessWidget {
  const TabNavigatorComponent(
      {super.key, required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItemEnum tabItem;

  void ppush(BuildContext context) {
    var routeBuilders = prouteBuilders(context);

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  Map<String, WidgetBuilder> prouteBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => const Placeholder(),
      TabNavigatorRoutes.detail: (context) => const Placeholder(),
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
