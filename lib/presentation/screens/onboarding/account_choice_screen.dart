import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/buttons/primary_button.dart';

/// A screen that allows users to choose between a quick start
/// (anonymous) or creating an account.
class AccountChoiceScreen extends StatefulWidget {
  /// Callback function when the user taps the "Continue" button
  final VoidCallback? onContinue;

  /// Creates an account choice screen.
  const AccountChoiceScreen({
    super.key,
    this.onContinue,
  });

  @override
  State<AccountChoiceScreen> createState() => _AccountChoiceScreenState();
}

class _AccountChoiceScreenState extends State<AccountChoiceScreen> {
  // Choice options
  final _choices = [
    {
      'id': 'quick_start',
      'title': 'Quick Start',
      'subtitle': 'Get started immediately with basic features',
      'benefits': [
        'No account required',
        'No email or personal information needed',
        'Start driving immediately',
      ],
      'limitations': [
        'Some features limited',
        'Progress not synced between devices',
      ],
    },
    {
      'id': 'create_account',
      'title': 'Create Account',
      'subtitle': 'Access all features and sync your data',
      'benefits': [
        'Access all premium features',
        'Save data across multiple devices',
        'Join challenges and leaderboards',
        'Track your progress long-term',
      ],
    },
  ];

  // Selected choice
  String? _selectedChoiceId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with app logo
          Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Icon(
                  Icons.eco, // Placeholder icon - replace with actual logo
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  AppInfo.appName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Question headline
          Text(
            'How would you like to continue?',
            style: theme.textTheme.headlineSmall,
          ),
          
          const SizedBox(height: 24),
          
          // Choice cards
          Expanded(
            child: ListView.builder(
              itemCount: _choices.length,
              itemBuilder: (context, index) {
                final choice = _choices[index];
                final isSelected = _selectedChoiceId == choice['id'];
                
                return _ChoiceCard(
                  title: choice['title'] as String,
                  subtitle: choice['subtitle'] as String,
                  benefits: choice['benefits'] as List<String>,
                  limitations: (choice['limitations'] as List<String>?) ?? [],
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedChoiceId = choice['id'] as String;
                    });
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Continue button
          PrimaryButton(
            text: 'Continue',
            onPressed: _selectedChoiceId == null
                ? null
                : () {
                    // Handle the selected choice
                    if (_selectedChoiceId == 'quick_start') {
                      // Set user as anonymous
                      final userProvider = Provider.of<UserProvider>(
                        context, 
                        listen: false
                      );
                      
                      // TODO: Implement proper quick start flow
                      // In the future, we would use userProvider to set anonymous user
                      
                    } else if (_selectedChoiceId == 'create_account') {
                      // Set up for account creation
                      // TODO: Implement account creation flow
                    }
                    
                    // Continue to next screen
                    if (widget.onContinue != null) {
                      widget.onContinue!();
                    }
                  },
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

/// A card widget that represents a choice option.
class _ChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> benefits;
  final List<String> limitations;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.benefits,
    required this.limitations,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and selection indicator
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Benefits
            ...benefits.map((benefit) => _BulletItem(
              text: benefit,
              iconColor: theme.colorScheme.primary,
            )),
            
            // Limitations (if any)
            if (limitations.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...limitations.map((limitation) => _BulletItem(
                text: limitation,
                iconColor: theme.colorScheme.error,
                isNegative: true,
              )),
            ],
          ],
        ),
      ),
    );
  }
}

/// A bullet point list item.
class _BulletItem extends StatelessWidget {
  final String text;
  final Color iconColor;
  final bool isNegative;

  const _BulletItem({
    required this.text,
    required this.iconColor,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isNegative ? Icons.remove_circle_outline : Icons.check_circle_outline,
            size: 16,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
} 