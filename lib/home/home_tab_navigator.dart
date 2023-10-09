import 'package:challenge/components/add_acceptance_criteria.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/components/edit_challenge.dart';
import 'package:challenge/home/home_challenge.dart';
import 'package:challenge/home/home_list.dart';
import 'package:challenge/models/challenge.dart';
import 'package:challenge/components/tab_navigator.dart';

class HomeTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
  static const String newChallenge = '/newChallenge';
  static const String addAcceptanceCriteria = '/addAcceptanceCriteria';
}
class HomeTabNavigator extends TabNavigator {
  
  const HomeTabNavigator({super.key, required super.navigatorKey, required super.tabItem});

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
    final Challenge challenge = Challenge(id: 0, status: ChallengStatus.backlog, title: 'New Challenge', description: '', thumbnailPath: '', startDate: DateTime.now(), endDate: DateTime.now(), acceptanceCriteria: [AcceptanceCriteria(activity: Activity(title: '', amount: 0, unit: ''), frequence: '', tracking: '', progress: 0)]);
    var routeBuilders = prouteBuilders(context, challenge: challenge);

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            routeBuilders[HomeTabNavigatorRoutes.newChallenge]!(context),
      ),
    );
  }

    @override
    Map<String, WidgetBuilder> prouteBuilders(BuildContext context,
      {int challengeId = 0, Challenge? challenge}) {
    return {
      HomeTabNavigatorRoutes.root: (context) => HomeList(
            title: tabItem.name,
            onPush: (c) =>
                ppush(context, challenge: c),
            tapOnNewChallenge: () => tapOnNewChallenge(context)
          ),
      HomeTabNavigatorRoutes.detail: (context) => HomeChallenge(
            title: tabItem.name,
            challenge: challenge!,
          ),
      HomeTabNavigatorRoutes.newChallenge: (context) => EditChallenge(
            title: tabItem.name,
            challenge: challenge!,
          ),
      HomeTabNavigatorRoutes.addAcceptanceCriteria: (context) => AddAcceptanceCriteria(
            title: tabItem.name,
            challenge: challenge!,
          ),
    };
  }

}