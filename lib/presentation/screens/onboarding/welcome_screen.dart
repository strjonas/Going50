import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/buttons/primary_button.dart';

/// The initial welcome screen of the onboarding flow.
///
/// This screen introduces the app to new users and provides
/// a brief overview of the value proposition.
class WelcomeScreen extends StatelessWidget {
  /// Callback function when the user taps the "Get Started" button
  final VoidCallback? onGetStarted;

  /// Creates a welcome screen.
  const WelcomeScreen({
    super.key,
    this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section with logo and tagline
          Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              // App logo
              const Icon(
                Icons.eco, // Using placeholder icon - replace with actual logo
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              // App name
              Text(
                AppInfo.appName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Tagline
              Text(
                'Drive Smart, Live Green',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Value proposition
              Text(
                'Cut your fuel costs by up to 25% and reduce your carbon footprint with personalized eco-driving insights.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          
          // Bottom section with CTA buttons
          Column(
            children: [
              // Primary CTA
              PrimaryButton(
                text: 'Get Started',
                onPressed: onGetStarted,
                fullWidth: true,
              ),
              const SizedBox(height: 16),
              // Secondary CTA (login link)
              GestureDetector(
                onTap: () {
                  // TODO: Implement login flow when available
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login feature coming soon'),
                    ),
                  );
                },
                child: Text(
                  'Already have an account? Log in',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ],
      ),
    );
  }
} 