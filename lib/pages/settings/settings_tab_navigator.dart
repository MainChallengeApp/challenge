import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/settings/settings_list_page.dart';
import 'package:challenge/components/navigation/tab_navigator_component.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';

class SettingsTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
}

class SettingsTabNavigator extends TabNavigatorComponent {
  const SettingsTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

  @override
  void push(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    var buildRoutes = routeBuilders(context, challenge: challenge!);

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => buildRoutes[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  @override
  Map<String, WidgetBuilder> routeBuilders(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    return {
      SettingsTabNavigatorRoutes.root: (context) => SettingsListPage(
            title: tabItem.name,
            onPush: (c) => push(context, challenge: c),
          ),
    };
  }
}
