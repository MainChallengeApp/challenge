import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationComponent extends StatefulWidget {
  static const double standardMargin = 20;
  static const double standardBorderRadius = 24;
  static const double standardHeight = 81;
  static const double standardIndicatorSize = 50;
  static const double standardIndicatorRadius = 16;

  const BottomNavigationComponent({super.key});

  @override
  State<BottomNavigationComponent> createState() =>
      _BottomNavigationComponentState();
}

class _BottomNavigationComponentState extends State<BottomNavigationComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: BottomNavigationComponent.standardMargin,
          right: BottomNavigationComponent.standardMargin,
          bottom: BottomNavigationComponent.standardMargin,
          top: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
              BottomNavigationComponent.standardBorderRadius),
        ),
        height: BottomNavigationComponent.standardHeight,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _bottomNavIcon(TabItemEnum.search),
              _bottomNavIcon(TabItemEnum.home),
              _bottomNavIcon(TabItemEnum.user),
            ],
          ),
        ),
      ),
    );
  }

  Map<TabItemEnum, bool> isHighlighted = {
    TabItemEnum.search: false,
    TabItemEnum.home: false,
    TabItemEnum.user: false,
  };
  _bottomNavIcon(TabItemEnum tabItem) {
    double iconSize = 26;
    Widget icon = tabItem == TabItemEnum.search
        ? Text(
            String.fromCharCode(IconEnum.search.icon.codePoint),
            style: TextStyle(
              color: Colors.white,
              inherit: false,
              fontSize: iconSize,
              fontWeight: FontWeight.w600,
              fontFamily: IconEnum.search.icon.fontFamily,
            ),
            textScaler: TextScaler.noScaling,
          )
        : tabItem == TabItemEnum.home
            ? const ImageIcon(
                AssetImage('assets/icons/challenge_icon.png'),
                color: Colors.white,
              )
            : Icon(
                IconEnum.user.icon,
                color: Colors.white,
                size: iconSize,
              );
    bool isSelected = context.watch<TabProvider>().currentTab == tabItem;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTapIcon(tabItem),
        onTapDown: (_) => setState(() {
          isHighlighted[tabItem] = true;
        }),
        onTapUp: (details) => setState(() {
          isHighlighted[tabItem] = false;
        }),
        onTapCancel: () => setState(() {
          isHighlighted[tabItem] = false;
        }),
        child: Container(
          color: Colors.transparent,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                      BottomNavigationComponent.standardIndicatorRadius),
                ),
                width: isSelected
                    ? BottomNavigationComponent.standardIndicatorSize
                    : 0,
                height: isSelected
                    ? BottomNavigationComponent.standardIndicatorSize
                    : 0,
              ),
              // AnimatedContainer(
              //   duration: const Duration(milliseconds: 50),
              //   height: isHighlighted[tabItem]!
              //       ? BottomNavigationComponent.standardIndicatorSize
              //       : 0,
              //   width: isHighlighted[tabItem]!
              //       ? BottomNavigationComponent.standardIndicatorSize
              //       : 0,
              //   decoration: BoxDecoration(
              //     color: isHighlighted[tabItem]!
              //         ? Theme.of(context).colorScheme.secondary.withAlpha(100)
              //         : Colors.transparent,
              //     borderRadius: BorderRadius.circular(
              //         BottomNavigationComponent.standardIndicatorRadius),
              //   ),
              // ),
              icon
            ],
          ),
        ),
      ),
    );
  }

  void onTapIcon(TabItemEnum tabItem) {
    context.read<TabProvider>().selectTab(tabItem);
  }
}
