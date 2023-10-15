import 'package:flutter/widgets.dart';
import 'package:challenge/pages/home/home_challenge.dart';
import 'package:challenge/models/challenge.dart';
import 'package:challenge/pages/settings/settings_list.dart';
import 'package:challenge/components/navigation/tab_navigator.dart';

class SettingsTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
}
class SettingsTabNavigator extends TabNavigator {
  
  const SettingsTabNavigator({super.key, required super.navigatorKey, required super.tabItem});

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


void tapOnNewChallenge(BuildContext context) {
    final Challenge challenge = Challenge(id: 0, status: ChallengStatus.backlog, title: 'new Challenge', description: '', thumbnailPath: '', startDate: DateTime.now(), endDate: DateTime.now(), acceptanceCriteria: [], media: []);
    var routeBuilders = prouteBuilders(context, challenge: challenge);

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            routeBuilders[SettingsTabNavigatorRoutes.newChallenge]!(context),
      ),
    );
  }

    @override
    Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    return {
      SettingsTabNavigatorRoutes.root: (context) => SettingsList(
            title: tabItem.name,
            onPush: (c) =>
                ppush(context, challenge: c),
          ),
      // SettingsTabNavigatorRoutes.detail: (context) => HomeChallenge(
      //       preTitle: tabItem.name,
      //       challenge: challenge!,
      //     ),
    };
  }

}