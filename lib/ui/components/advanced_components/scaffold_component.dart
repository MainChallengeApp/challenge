import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class ScaffoldComponent extends StatefulWidget {
  final bool isBottomNavigationVisible;
  final AppBarComponent? appBar;
  final Widget body;
  final bool? resizeToAvoidBottomInset;

  const ScaffoldComponent({
    super.key,
    this.appBar,
    required this.body,
    this.isBottomNavigationVisible = true,
    this.resizeToAvoidBottomInset = false,
  });

  @override
  State<ScaffoldComponent> createState() => _ScaffoldComponentState();
}

class _ScaffoldComponentState extends State<ScaffoldComponent> {
  final _tabProvider = getIt<TabProvider>();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabProvider
          .setBottomNavigationVisibility(widget.isBottomNavigationVisible);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Column(
        children: [
          Expanded(child: widget.body),
          if (widget.isBottomNavigationVisible)
            const SpaceComponent(
              height: BottomNavigationComponent.standardHeight +
                  BottomNavigationComponent.standardMargin,
            ),
        ],
      ),
    );
  }
}
