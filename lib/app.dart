import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'navigation/tab_navigator.dart';
import 'navigation/app_router.dart';
import 'services/driving/driving_service.dart';
import 'services/driving/performance_metrics_service.dart';
import 'services/service_locator.dart';
import 'presentation/providers/driving_provider.dart';
import 'presentation/providers/insights_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/social_provider.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'services/user/user_service.dart';
import 'services/user/preferences_service.dart';
import 'services/user/privacy_service.dart';
import 'services/social/social_service.dart';
import 'services/social/leaderboard_service.dart';
import 'services/social/sharing_service.dart';

/// The main application widget for Going50.
///
/// This widget sets up the application theme and navigation.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Whether the user has completed onboarding
  bool _onboardingComplete = false;
  
  /// Loading state
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
    
    // Initialize the PrivacyService
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize privacy service after frame is rendered
      await serviceLocator<PrivacyService>().initialize();
      
      // Log the privacy settings to debug
      final privacyService = serviceLocator<PrivacyService>();
      debugPrint('Privacy settings after initialization: ${privacyService.privacySettings}');
    });
  }

  /// Check if the user has completed onboarding
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _loading = false;
    });
  }
  
  /// Mark onboarding as complete
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    setState(() {
      _onboardingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Set up providers
        ChangeNotifierProvider(
          create: (_) => DrivingProvider(serviceLocator<DrivingService>())),
        ChangeNotifierProvider(
          create: (_) => InsightsProvider(
            serviceLocator<DrivingService>(),
            serviceLocator<PerformanceMetricsService>(),
          )),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(
            serviceLocator<UserService>(),
            serviceLocator<PreferencesService>(),
          )
        ),
        ChangeNotifierProvider(
          create: (_) => SocialProvider(
            serviceLocator<SocialService>(),
            serviceLocator<LeaderboardService>(),
            serviceLocator<SharingService>(),
          )),
        // Add Privacy Service Provider
        Provider<PrivacyService>(
          create: (_) => serviceLocator<PrivacyService>(),
        ),
      ],
      child: MaterialApp(
        title: AppInfo.appName,
        theme: AppTheme.getLightTheme(),
        darkTheme: AppTheme.getDarkTheme(),
        themeMode: ThemeMode.system, // Respect system theme settings
        
        // Show loading indicator, onboarding, or main app depending on state
        home: _loading 
            ? const _LoadingScreen() 
            : _onboardingComplete 
                ? const TabNavigator()
                : OnboardingScreen(
                    onComplete: _completeOnboarding,
                  ),
        
        // Set up the router for handling named routes
        onGenerateRoute: AppRouter.generateRoute,
        
        // Customize app bar theme
        builder: (context, child) {
          return child!;
        },
        
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// A simple loading screen shown while checking onboarding status
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 