import 'package:flutter/material.dart';
import 'package:challenge/enums/tab_item_enum.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

abstract class TabNavigatorComponent extends StatelessWidget {
  const TabNavigatorComponent(
      {super.key, required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItemEnum tabItem;

  void push(BuildContext context);

  Map<String, WidgetBuilder> routeBuilders(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final buildRoutes = routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => buildRoutes[routeSettings.name!]!(context),
        );
      },
    );
  }
}
