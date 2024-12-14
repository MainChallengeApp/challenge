import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final bool isFirstPageInRoute;
  final Widget? leadingIcon;
  final List<Widget>? actions;

  final double appBarFontSize = 21;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const AppBarComponent(
      {super.key,
      required this.title,
      this.textColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.isFirstPageInRoute = false,
      this.leadingIcon,
      this.actions});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          scrollController.position.hasContentDimensions) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    return Padding(
      padding: const EdgeInsets.only(
          right: BottomNavigationComponent.standardMargin),
      child: AppBar(
          elevation: 0,
          leading: leadingIcon ??
              (isFirstPageInRoute
                  ? const Icon(
                      Icons.chevron_left,
                      color: Colors.transparent,
                    )
                  : null),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(right: (actions?.isEmpty ?? true) ? 0 : 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          actions: actions),
    );
  }
}
