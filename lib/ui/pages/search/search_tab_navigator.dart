import 'package:challenge/ui/components/navigation/tab_navigator_component.dart';
import 'package:challenge/ui/pages/search/search_categories_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SearchTabNavigatorRoutes {
  static const String root = '/';
}

class SearchTabNavigator extends TabNavigatorComponent {
  const SearchTabNavigator(
      {super.key, required super.navigatorKey, required super.tabItem});

  @override
  Map<String, WidgetBuilder> routeBuilders(BuildContext context) {
    return {
      SearchTabNavigatorRoutes.root: (context) => SearchCategoriesPage(
            title: tabItem.name,
          ),
    };
  }
}
