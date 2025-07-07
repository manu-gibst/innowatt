import 'package:flutter/widgets.dart';

enum PageTransitions {
  pushUp,
  pushDown,
  pushRight,
  pushLeft;

  Widget transitionsBuilder(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, child) {
    final offset = switch (this) {
      PageTransitions.pushDown => Offset(0, -1),
      PageTransitions.pushUp => Offset(0, 1),
      PageTransitions.pushRight => Offset(-1, 0),
      PageTransitions.pushLeft => Offset(1, 0),
    };
    return SlideTransition(
      position: Tween<Offset>(
        begin: offset,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
