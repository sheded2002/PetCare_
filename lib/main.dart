import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_care/database/database_helper.dart';
import 'package:pet_care/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/locale_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'theme/app_theme.dart';
import 'services/navigation_service.dart';

// Entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service for app notifications
  await NotificationService().initialize();

  // Initialize database singleton
  DatabaseHelper();

  // Get shared preferences instance for app settings
  final prefs = await SharedPreferences.getInstance();
  
  // Check if user has seen onboarding and login status
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Run the app with locale provider for language support
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: MyApp(
        hasSeenOnboarding: hasSeenOnboarding,
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

// Root widget of the application
class MyApp extends StatelessWidget {
  // State flags for app initialization
  final bool hasSeenOnboarding;
  final bool isLoggedIn;

  const MyApp({
    Key? key,
    required this.hasSeenOnboarding,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Pet Care',
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          
          // Configure app theme with page transitions
          theme: AppTheme.lightTheme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                // Custom transitions for different platforms
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          
          // Configure localization
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en'),  // English
            Locale('ar'),  // Arabic
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Determine initial screen based on app state
          home: !hasSeenOnboarding
              ? const OnboardingScreen()  // Show onboarding for first-time users
              : isLoggedIn
                  ? const HomeScreen()    // Show home screen for logged-in users
                  : const LoginScreen(),  // Show login screen otherwise
        );
      },
    );
  }
}
