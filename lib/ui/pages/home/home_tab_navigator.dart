import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/navigation/tab_navigator_component.dart';
import 'package:challenge/ui/pages/home/home_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class HomeTabNavigatorRoutes {
  static const String root = '/';
}

class HomeTabNavigator extends TabNavigatorComponent {
  const HomeTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

  @override
  Map<String, WidgetBuilder> routeBuilders(BuildContext context,
      {int challengeId = 0, ChallengeModel? challenge}) {
    return {
      HomeTabNavigatorRoutes.root: (context) =>
          HomeListPage(title: tabItem.name),
    };
  }
}
