import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/components/tab_item.dart';

import '../globals.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation(
      {super.key, required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: themeColor1),
      // height: 100,
      // width: 350,
      padding: const EdgeInsets.only(top: 5),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            widget.onSelectTab(
            TabItem.values[index]);
          });
        },
        indicatorColor: themeColor2,
        indicatorShape: const RoundedRectangleBorder(side: BorderSide(width: 0, ), borderRadius: BorderRadius.all(Radius.circular(16))),
        backgroundColor: themeColor1,
        selectedIndex: widget.currentTab.index,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(TabItem.Search.icon, color: Colors.white),
            icon: Icon(TabItem.Search.icon, color: Colors.white,),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(TabItem.Home.icon, color: Colors.white),
            icon: Icon(TabItem.Home.icon, color: Colors.white),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(TabItem.Settings.icon, color: Colors.white),
            icon: Icon(TabItem.Settings.icon, color: Colors.white),
            label: '',
          ),
        ],
      ),
      ),
    );
  }

  // BottomNavigationBarItem _buildItem(TabItem tabItem) {
  //   return BottomNavigationBarItem(
  //   backgroundColor: Colors.green,
  //   label: '',
  //   icon: Icon(
  //   tabItem.icon,
  //   color: Colors.white),
  //   );
  // }

  // Color _colorTabMatching(TabItem item) {
  //   return widget.currentTab == item ?  const Color.fromRGBO(15, 23, 42, 1): Colors.grey;
  // }
}


// BottomNavigationBar(
//           selectedFontSize: 0,
//           unselectedFontSize: 0,

//           type: BottomNavigationBarType.fixed,
//           unselectedLabelStyle: const TextStyle(fontSize: 0),
//           selectedLabelStyle: const TextStyle(fontSize: 0),
//           backgroundColor: const Color.fromRGBO(15, 23, 42, 1),
//           elevation: 0,
//           items: [
//             _buildItem(TabItem.Search),
//             _buildItem(TabItem.Home),
//             _buildItem(TabItem.Settings),
//           ],
//           onTap: (index) => onSelectTab(
//             TabItem.values[index],
//           ),
//           currentIndex: currentTab.index,
//           // selectedItemColor: const Color.fromRGBO(15, 23, 42, 1),
//         ),