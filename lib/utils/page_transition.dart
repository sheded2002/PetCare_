import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  scale,
  slide,
  slideUp,
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType type;
  final Duration duration;

  CustomPageRoute({
    required this.child,
    this.type = PageTransitionType.slide,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            switch (type) {
              case PageTransitionType.fade:
                return FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(curvedAnimation),
                  child: child,
                );
              case PageTransitionType.scale:
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.5,
                      end: 1.0,
                    ).animate(curvedAnimation),
                    child: child,
                  ),
                );
              case PageTransitionType.slide:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                );
              case PageTransitionType.slideUp:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(curvedAnimation),
                    child: child,
                  ),
                );
            }
          },
        );
}
