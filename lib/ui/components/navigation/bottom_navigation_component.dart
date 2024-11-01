import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationComponent extends StatefulWidget {
  static const double standardMargin = 20;
  static const double standardBorderRadius = 24;

  const BottomNavigationComponent({super.key});

  @override
  State<BottomNavigationComponent> createState() =>
      _BottomNavigationComponentState();
}

class _BottomNavigationComponentState extends State<BottomNavigationComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
            left: BottomNavigationComponent.standardMargin,
            right: BottomNavigationComponent.standardMargin,
            bottom: BottomNavigationComponent.standardMargin,
            top: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            height: 81,
            // width: 450,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Container(
              height: 81,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(
                    BottomNavigationComponent.standardBorderRadius)),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(
                      parent: NeverScrollableScrollPhysics()),
                  child: NavigationBar(
                    onDestinationSelected: onTapIcon,
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    indicatorShape: const RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    selectedIndex:
                        context.watch<TabProvider>().currentTab.index,
                    elevation: 0,
                    destinations: <Widget>[
                      search(),
                      home(),
                      user(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTapIcon(int index) {
    context.read<TabProvider>().selectTab(TabItemEnum.values[index]);
  }

  NavigationDestination user() {
    return NavigationDestination(
      selectedIcon: Icon(IconEnum.user.icon, color: Colors.white, size: 29),
      icon: Icon(IconEnum.user.icon, color: Colors.white, size: 29),
      label: '',
    );
  }

  NavigationDestination home() {
    return const NavigationDestination(
      selectedIcon: ImageIcon(
        AssetImage('assets/icons/challenge_icon.png'),
        color: Colors.white,
      ),
      icon: ImageIcon(
        AssetImage('assets/icons/challenge_icon.png'),
        color: Colors.white,
      ), //Icon(TabItem.Home.icon, color: Colors.white),
      label: '',
    );
  }

  NavigationDestination search() {
    return NavigationDestination(
      selectedIcon: Text(
        String.fromCharCode(IconEnum.search.icon.codePoint),
        style: TextStyle(
          color: Colors.white,
          inherit: false,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          fontFamily: IconEnum.search.icon.fontFamily,
        ),
      ),
      icon: Text(
        String.fromCharCode(IconEnum.search.icon.codePoint),
        style: TextStyle(
          color: Colors.white,
          inherit: false,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          fontFamily: IconEnum.search.icon.fontFamily,
        ),
      ),
      label: '',
    );
  }
}
