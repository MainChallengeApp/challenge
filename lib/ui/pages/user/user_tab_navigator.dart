import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/navigation/tab_navigator_component.dart';
import 'package:challenge/ui/pages/user/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class UserTabNavigatorRoutes {
  static const String root = '/';
}

class UserTabNavigator extends TabNavigatorComponent {
  const UserTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

  @override
  Map<String, WidgetBuilder> routeBuilders(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    return {
      UserTabNavigatorRoutes.root: (context) => UserPage(
            title: tabItem.name,
          ),
    };
  }
}
