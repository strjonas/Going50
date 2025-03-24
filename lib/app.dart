import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'navigation/tab_navigator.dart';
import 'navigation/app_router.dart';

/// The main application widget for Going50.
///
/// This widget sets up the application theme and navigation.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appName,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system, // Respect system theme settings
      
      // Use the TabNavigator as the home widget for the main tabs
      home: const TabNavigator(),
      
      // Set up the router for handling named routes
      onGenerateRoute: AppRouter.generateRoute,
      
      // Customize app bar theme
      builder: (context, child) {
        return child!;
      },
      
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
} 