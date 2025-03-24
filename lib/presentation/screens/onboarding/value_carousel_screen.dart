import 'package:flutter/material.dart';
import '../../widgets/common/buttons/primary_button.dart';
import '../../widgets/common/buttons/secondary_button.dart';

/// A screen that showcases the core benefits of the app through
/// a carousel of value propositions.
class ValueCarouselScreen extends StatefulWidget {
  /// Callback function when the user taps the "Next" or "Get Started" button
  final VoidCallback? onNext;
  
  /// Callback function when the user taps the "Skip" button
  final VoidCallback? onSkip;

  /// Creates a value carousel screen.
  const ValueCarouselScreen({
    super.key,
    this.onNext,
    this.onSkip,
  });

  @override
  State<ValueCarouselScreen> createState() => _ValueCarouselScreenState();
}

class _ValueCarouselScreenState extends State<ValueCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _values = [
    {
      'icon': Icons.savings_outlined,
      'title': 'Save Money',
      'description': 'Reduce fuel consumption by up to 25% with personalized eco-driving feedback.',
    },
    {
      'icon': Icons.nature_people_outlined,
      'title': 'Reduce Emissions',
      'description': 'Cut your carbon footprint and contribute to a cleaner environment.',
    },
    {
      'icon': Icons.sports_score_outlined,
      'title': 'Track Progress',
      'description': 'Monitor your improvement and compete with friends to become an eco-driving champion.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        // Skip button at top right
        Positioned(
          top: 16,
          right: 16,
          child: TextButton(
            onPressed: widget.onSkip,
            child: Text('Skip', style: theme.textTheme.bodyLarge),
          ),
        ),
        
        // Main content
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top space
              const SizedBox(height: 56),
              
              // Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _values.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final value = _values[index];
                    return _ValuePageItem(
                      icon: value['icon'],
                      title: value['title'],
                      description: value['description'],
                    );
                  },
                ),
              ),
              
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _values.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Next/Get Started button
              _currentPage == _values.length - 1
                  ? PrimaryButton(
                      text: 'Get Started',
                      onPressed: widget.onNext,
                    )
                  : SecondaryButton(
                      text: 'Next',
                      onPressed: () {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
              
              // Bottom space
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ],
    );
  }
}

/// A single page item in the value carousel.
class _ValuePageItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ValuePageItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Icon(
          icon,
          size: 120,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 32),
        
        // Title
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // Description
        Text(
          description,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 