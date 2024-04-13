import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/settings/settings_list_page.dart';
import 'package:challenge/pages/components/navigation/tab_navigator_component.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';

class SettingsTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
}

class SettingsTabNavigator extends TabNavigatorComponent {
  const SettingsTabNavigator(
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
      SettingsTabNavigatorRoutes.root: (context) => SettingsListPage(
            title: tabItem.name,
            onPush: (c) => ppush(context, challenge: c),
          ),
      // SettingsTabNavigatorRoutes.detail: (context) => HomeChallenge(
      //       preTitle: tabItem.name,
      //       challenge: challenge!,
      //     ),
    };
  }
}
