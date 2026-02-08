import 'package:flutter/material.dart';

class OrchidPageRoute<T> extends MaterialPageRoute<T> {
  OrchidPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = animation.drive(CurveTween(curve: Curves.easeOut));
    final slideAnimation = curvedAnimation.drive(
      Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero),
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
