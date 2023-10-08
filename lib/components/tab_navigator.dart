import 'package:flutter/material.dart';
import 'package:challenge/color_detail_page.dart';
import 'package:challenge/colors_list_page.dart';
import 'package:challenge/models/challenge.dart';
import 'package:challenge/components/tab_item.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {super.key, required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  void ppush(BuildContext context, {int challengeId = 0
  , Challenge? challenge
  }) {
    var routeBuilders = prouteBuilders(context, challengeId: challengeId
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

  Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    return {
      TabNavigatorRoutes.root: (context) => ColorsListPage(
            title: tabItem.name,
            onPush: (challengeId) =>
                ppush(context, challengeId: challengeId
                ),
          ),
      TabNavigatorRoutes.detail: (context) => ColorDetailPage(
            title: tabItem.name,
            challengeId: challengeId,
            // challenge: challenge,
          ),
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
