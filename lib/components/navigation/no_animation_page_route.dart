import 'package:flutter/cupertino.dart';

class NoAnimationPageRoute extends CupertinoPageRoute {
  NoAnimationPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  // @override
  // Widget buildTransitions(BuildContext context, Animation<double> animation,
  //     Animation<double> secondaryAnimation, Widget child) {
  //   Tween<Offset> offsetTween =
  //       Tween(begin: const Offset(1, 0), end: Offset.zero);
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: FractionalTranslation(
  //       translation: offsetTween.evaluate(animation),
  //       child: child,
  //     ),
  //   );
  // }
  @override
  Duration get transitionDuration => Duration.zero;
}
