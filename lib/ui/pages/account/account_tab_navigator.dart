import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/navigation/tab_navigator_component.dart';
import 'package:challenge/ui/pages/account/account_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class ProfileTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
}

class ProfileTabNavigator extends TabNavigatorComponent {
  const ProfileTabNavigator(
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
      ProfileTabNavigatorRoutes.root: (context) => AccountPage(
            title: tabItem.name,
            onPush: (c) => push(context, challenge: c),
          ),
    };
  }
}
