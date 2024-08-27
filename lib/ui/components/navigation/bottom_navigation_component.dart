import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationComponent extends StatefulWidget {
  static const double standardMargin = 24;

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
        padding:
            const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20, top: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            height: 81,
            // width: 450,
            decoration: const BoxDecoration(
              color: themeColor1,
            ),
            child: Container(
              height: 81,
              decoration: const BoxDecoration(
                color: themeColor1,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(
                      parent: NeverScrollableScrollPhysics()),
                  child: NavigationBar(
                    onDestinationSelected: onTapIcon,
                    indicatorColor: themeColor2,
                    indicatorShape: const RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    backgroundColor: themeColor1,
                    selectedIndex:
                        context.watch<TabProvider>().currentTab.index,
                    elevation: 0,
                    destinations: <Widget>[
                      search(),
                      home(),
                      profile(),
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

  NavigationDestination profile() {
    return NavigationDestination(
      selectedIcon: Icon(IconEnum.profile.icon, color: Colors.white, size: 29),
      icon: Icon(IconEnum.profile.icon, color: Colors.white, size: 29),
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
