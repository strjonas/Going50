import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/core/theme/app_colors.dart';

/// ProfileHeader displays the user's profile information at the top of the profile screen.
///
/// This includes the user's name, profile picture, eco-score, and impact statistics.
class ProfileHeader extends StatelessWidget {
  /// Constructor
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final insightsProvider = Provider.of<InsightsProvider>(context);
    final theme = Theme.of(context);
    
    // Get the user's eco score
    final overallScore = insightsProvider.currentMetrics?.overallEcoScore ?? 0;
    
    return Column(
      children: [
        // User info section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark ? 
                         AppColors.darkSurface : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: theme.brightness == Brightness.dark ? 
                           Colors.grey.shade400 : Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              
              // User name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.userProfile?.name ?? 'Green Driver',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProvider.isAnonymous 
                          ? 'Anonymous User' 
                          : (userProvider.userProfile?.email ?? 'No email'),
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getColorForScore(overallScore.toDouble()).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getDriverLevelFromScore(overallScore.toDouble()),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getColorForScore(overallScore.toDouble()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Eco-Score section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Eco-Score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    '$overallScore',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getColorForScore(overallScore.toDouble()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: overallScore / 100,
                backgroundColor: theme.brightness == Brightness.dark ? 
                                 Colors.grey.shade800 : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForScore(overallScore.toDouble()),
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Total impact statistics
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImpactStat(
                context,
                Icons.local_gas_station,
                '${(insightsProvider.fuelSavings).toStringAsFixed(1)} L',
                'Fuel Saved'
              ),
              _buildImpactStat(
                context,
                Icons.co2,
                '${(insightsProvider.co2Reduction).toStringAsFixed(1)} kg',
                'CO₂ Reduced'
              ),
              _buildImpactStat(
                context,
                Icons.attach_money,
                '\$${(insightsProvider.moneySavings).toStringAsFixed(1)}',
                'Money Saved'
              ),
            ],
          ),
        ),
        
        // Edit button (only for non-anonymous users)
        if (!userProvider.isAnonymous)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton.icon(
              onPressed: () {
                // TODO: Navigate to profile edit screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile editing not yet implemented'),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit Profile'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton.icon(
              onPressed: () {
                // TODO: Navigate to account creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account creation not yet implemented'),
                  ),
                );
              },
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Create Account'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
  
  /// Builds an impact statistic item
  Widget _buildImpactStat(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  /// Returns a user-friendly driver level based on eco-score
  String _getDriverLevelFromScore(double score) {
    if (score < 20) return 'Eco-Driving Beginner';
    if (score < 40) return 'Eco-Driving Novice';
    if (score < 60) return 'Eco-Driving Apprentice';
    if (score < 80) return 'Eco-Driving Pro';
    return 'Eco-Driving Master';
  }
  
  /// Returns an appropriate color based on the eco-score
  Color _getColorForScore(double score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }
} 