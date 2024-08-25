import 'package:flutter/cupertino.dart';

class LoadingCircleComponent extends StatelessWidget {
  final Color? color;

  const LoadingCircleComponent({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color,
    );
  }
}
