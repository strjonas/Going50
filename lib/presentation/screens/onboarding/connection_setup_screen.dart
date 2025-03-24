import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/driving_provider.dart';
import '../../widgets/common/buttons/primary_button.dart';

/// A screen that guides users through OBD connection options.
class ConnectionSetupScreen extends StatefulWidget {
  /// Callback function when the user taps the "Continue" button
  final VoidCallback? onContinue;

  /// Creates a connection setup screen.
  const ConnectionSetupScreen({
    super.key,
    this.onContinue,
  });

  @override
  State<ConnectionSetupScreen> createState() => _ConnectionSetupScreenState();
}

class _ConnectionSetupScreenState extends State<ConnectionSetupScreen> {
  // Connection options
  String? _selectedOption;
  
  // Whether to show the OBD help dialog
  bool _showOBDHelp = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // Headline
              Text(
                'Choose your setup',
                style: theme.textTheme.headlineMedium,
              ),
              
              const SizedBox(height: 8),
              
              // Explanation text
              Text(
                'Going50 works with or without an OBD adapter. Choose the option that works best for you.',
                style: theme.textTheme.bodyLarge,
              ),
              
              const SizedBox(height: 24),
              
              // Connection options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Phone only option
                      _ConnectionOptionCard(
                        title: 'Phone only',
                        subtitle: 'Use your phone sensors for basic tracking',
                        icon: Icons.phone_android,
                        benefits: [
                          'No additional hardware required',
                          'Easy setup with no connections',
                          'Works in any vehicle',
                        ],
                        limitations: [
                          'Limited accuracy for some metrics',
                          'No engine-specific data available',
                        ],
                        isSelected: _selectedOption == 'phone_only',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'phone_only';
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // OBD adapter option
                      _ConnectionOptionCard(
                        title: 'Connect OBD adapter',
                        subtitle: 'Get enhanced data with an OBD2 adapter',
                        icon: Icons.bluetooth,
                        benefits: [
                          'Higher accuracy for all metrics',
                          'Real-time engine data',
                          'More detailed feedback and analysis',
                          'Better fuel savings estimates',
                        ],
                        isSelected: _selectedOption == 'obd_adapter',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'obd_adapter';
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Help link
                      Center(
                        child: TextButton.icon(
                          icon: const Icon(Icons.help_outline, size: 16),
                          label: const Text("What's an OBD adapter?"),
                          onPressed: () {
                            setState(() {
                              _showOBDHelp = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Continue button
              PrimaryButton(
                text: 'Continue',
                onPressed: _selectedOption == null
                    ? null
                    : () {
                        // Set the connection choice in the provider
                        final drivingProvider = Provider.of<DrivingProvider>(
                          context, 
                          listen: false
                        );
                        
                        if (_selectedOption == 'obd_adapter') {
                          // Users who want to use an OBD adapter should be taken to scan for devices
                          // This will be implemented in the next step - for now just set a flag
                          drivingProvider.setPreferOBD(true);
                          
                          // TODO: Show device scan screen when it's implemented
                          // For now, we'll just continue to the main app
                          if (widget.onContinue != null) {
                            widget.onContinue!();
                          }
                        } else {
                          // Users who want to use phone only can proceed directly
                          drivingProvider.setPreferOBD(false);
                          
                          if (widget.onContinue != null) {
                            widget.onContinue!();
                          }
                        }
                      },
              ),
              
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
        
        // OBD Help Dialog
        if (_showOBDHelp)
          _OBDHelpDialog(
            onClose: () {
              setState(() {
                _showOBDHelp = false;
              });
            },
          ),
      ],
    );
  }
}

/// A card widget for connection options.
class _ConnectionOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> benefits;
  final List<String>? limitations;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConnectionOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.benefits,
    this.limitations,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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
            
            const SizedBox(height: 16),
            
            // Benefits
            ...benefits.map((benefit) => _BulletItem(
              text: benefit,
              iconColor: theme.colorScheme.primary,
              isPositive: true,
            )),
            
            // Limitations
            if (limitations != null && limitations!.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...limitations!.map((limitation) => _BulletItem(
                text: limitation,
                iconColor: theme.colorScheme.error,
                isPositive: false,
              )),
            ],
          ],
        ),
      ),
    );
  }
}

/// A bullet point item for lists.
class _BulletItem extends StatelessWidget {
  final String text;
  final Color iconColor;
  final bool isPositive;

  const _BulletItem({
    required this.text,
    required this.iconColor,
    required this.isPositive,
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
            isPositive ? Icons.check_circle_outline : Icons.info_outline,
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

/// A dialog explaining what an OBD adapter is.
class _OBDHelpDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _OBDHelpDialog({
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {}, // Prevent tap through
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'What is an OBD adapter?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Content
                Text(
                  'An OBD (On-Board Diagnostics) adapter is a small device that plugs into your car\'s diagnostic port, usually located under the dashboard.',
                  style: theme.textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'When connected to Going50, it provides real-time engine data that enables more accurate eco-driving analysis and personalized feedback.',
                  style: theme.textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 16),
                
                // Where to buy
                Text(
                  'Where to get one:',
                  style: theme.textTheme.titleMedium,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  '• Auto parts stores like AutoZone or Advance Auto Parts\n'
                  '• Online retailers like Amazon or eBay\n'
                  '• Electronics stores',
                  style: theme.textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Look for "ELM327 Bluetooth OBD2 Adapter" - they typically cost \$10-30.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Close button
                Center(
                  child: PrimaryButton(
                    text: 'Got it',
                    onPressed: onClose,
                    fullWidth: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 