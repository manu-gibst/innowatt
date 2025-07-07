import 'package:flutter/widgets.dart';

class PushUpPageRoute extends PageRouteBuilder {
  final Widget child;

  PushUpPageRoute({
    required this.child,
  }) : super(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    print("in buildTransitions()");
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
