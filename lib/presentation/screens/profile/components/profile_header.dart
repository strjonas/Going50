import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/presentation/providers/insights_provider.dart';

/// ProfileHeader displays the user's profile information and overall eco-driving level
class ProfileHeader extends StatelessWidget {
  /// Constructor
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final insightsProvider = Provider.of<InsightsProvider>(context);
    final UserProfile? profile = userProvider.userProfile;
    
    // Overall eco-score (from insights provider)
    final overallScore = insightsProvider.currentMetrics?.overallEcoScore ?? 0;
    final driverLevel = _getDriverLevelFromScore(overallScore.toDouble());
    
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            profile != null && !userProvider.isAnonymous
                ? Icons.person
                : Icons.person_outline,
            size: 50,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // User name
        Text(
          profile?.name ?? 'Anonymous User',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Eco-driver level badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.eco,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                driverLevel,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Progress bar for eco-score
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Eco-Driving Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$overallScore',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getColorForScore(overallScore.toDouble()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: overallScore / 100,
                backgroundColor: Colors.grey[200],
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
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
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