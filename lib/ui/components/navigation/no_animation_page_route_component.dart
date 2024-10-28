import 'package:flutter/cupertino.dart';

class NoAnimationPageRouteComponent extends CupertinoPageRoute {
  final bool disableSwipeBack;

  NoAnimationPageRouteComponent({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    this.disableSwipeBack = false,
  }) : super(
          builder: builder,
          maintainState: maintainState,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result =
        super.buildPage(context, animation, secondaryAnimation);
    if (disableSwipeBack) {
      return PopScope(
        canPop: false,
        child: result,
      );
    }
    return result;
  }
}
