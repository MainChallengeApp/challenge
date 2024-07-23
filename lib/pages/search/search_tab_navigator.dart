import 'package:challenge/pages/search/search_categories_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:challenge/pages/components/navigation/tab_navigator_component.dart';

import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';

class SearchTabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class SearchTabNavigator extends TabNavigatorComponent {
  const SearchTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

  @override
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

  @override
  Map<String, WidgetBuilder> prouteBuilders(BuildContext context) {
    return {
      SearchTabNavigatorRoutes.root: (context) => SearchCategoriesPage(
            title: tabItem.name,
          ),
      // SearchTabNavigatorRoutes.detail: (context) => SearchChallenge(
      //       title: tabItem.name,
      //       challenge: challenge!,
      //       selectTab: selectTab,
      //       challenges: const [],
      //     )
    };
  }
}
