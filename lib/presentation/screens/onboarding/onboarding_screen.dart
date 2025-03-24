import 'package:flutter/material.dart';
import '../../../core/constants/route_constants.dart';
import 'welcome_screen.dart';
import 'value_carousel_screen.dart';
import 'account_choice_screen.dart';
import 'connection_setup_screen.dart';

/// The main onboarding wrapper screen that manages navigation between
/// the different onboarding screens.
///
/// The onboarding flow consists of:
/// 1. Welcome screen
/// 2. Value carousel
/// 3. Account choice
/// 4. Connection setup
class OnboardingScreen extends StatefulWidget {
  /// Callback function when onboarding is complete
  final VoidCallback? onComplete;

  /// Creates an onboarding screen.
  const OnboardingScreen({
    super.key,
    this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const WelcomeScreen(),
    const ValueCarouselScreen(),
    const AccountChoiceScreen(),
    const ConnectionSetupScreen(),
  ];

  /// Navigate to the next page
  void _nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding and navigate to main app
      _completeOnboarding();
    }
  }

  /// Skip to the account choice screen
  void _skipToAccountChoice() {
    _pageController.animateToPage(
      2, // Index of AccountChoiceScreen
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Complete the onboarding flow and navigate to the main app
  void _completeOnboarding() {
    // Call the onComplete callback if provided
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
    
    // Navigate to the main app
    Navigator.of(context).pushReplacementNamed(TabRoutes.driveTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          physics: const ClampingScrollPhysics(),
          children: _pages.map((page) {
            if (page is WelcomeScreen) {
              return WelcomeScreen(onGetStarted: _nextPage);
            } else if (page is ValueCarouselScreen) {
              return ValueCarouselScreen(
                onNext: _nextPage,
                onSkip: _skipToAccountChoice,
              );
            } else if (page is AccountChoiceScreen) {
              return AccountChoiceScreen(onContinue: _nextPage);
            } else if (page is ConnectionSetupScreen) {
              return ConnectionSetupScreen(onContinue: _completeOnboarding);
            }
            return page;
          }).toList(),
        ),
      ),
    );
  }
} 