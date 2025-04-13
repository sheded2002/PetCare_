import 'package:flutter/material.dart';
import '../utils/page_transition.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(Widget page,
      {PageTransitionType? transitionType}) {
    return navigatorKey.currentState!.push(
      CustomPageRoute(
        child: page,
        // type: transitionType ?? PageTransitionType.slide,
        // duration: const Duration(milliseconds: 400),
      ),
    );
  }

  static Future<dynamic> navigateToReplacement(Widget page,
      {PageTransitionType? transitionType}) {
    return navigatorKey.currentState!.pushReplacement(
      CustomPageRoute(
        child: page,
        // type: transitionType ?? PageTransitionType.slide,
        // duration: const Duration(milliseconds: 400),
      ),
    );
  }

  static Future<dynamic> navigateToAndRemoveUntil(Widget page,
      {PageTransitionType? transitionType}) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      CustomPageRoute(
        child: page,
        // type: transitionType ?? PageTransitionType.slide,
        // duration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  static void goBack() {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
    }
  }
}
