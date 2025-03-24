import 'package:flutter/material.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core_models/trip.dart';

/// A section that displays savings metrics for a trip, including
/// fuel savings, CO2 emissions reduction, and money saved.
class SavingsMetricsSection extends StatelessWidget {
  /// The trip to calculate savings for
  final Trip trip;
  
  /// The eco-score, used to calculate savings
  final double ecoScore;
  
  /// Constructor
  const SavingsMetricsSection({
    super.key,
    required this.trip,
    required this.ecoScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate savings based on trip data and eco score
    final savingsData = _calculateSavings(trip, ecoScore);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Estimated Savings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Savings cards
          Row(
            children: [
              // Fuel savings
              Expanded(
                child: _buildSavingsCard(
                  context,
                  'Fuel Saved',
                  '${savingsData['fuelSaved']!.toStringAsFixed(2)} L',
                  Icons.local_gas_station,
                  AppColors.ecoScoreHigh,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // CO2 savings
              Expanded(
                child: _buildSavingsCard(
                  context,
                  'CO₂ Reduced',
                  '${savingsData['co2Reduced']!.toStringAsFixed(2)} kg',
                  Icons.cloud_outlined,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Money saved
          _buildSavingsCard(
            context,
            'Money Saved',
            '\$${savingsData['moneySaved']!.toStringAsFixed(2)}',
            Icons.attach_money,
            AppColors.secondary,
            large: true,
          ),
        ],
      ),
    );
  }
  
  /// Builds a savings card with an icon, title, and value
  Widget _buildSavingsCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    bool large = false,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(large ? 16 : 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: large ? 24 : 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Calculate savings based on trip and eco-score
  /// This uses simplified estimates that could be improved with more accurate models
  Map<String, double> _calculateSavings(Trip trip, double ecoScore) {
    // Default values if we don't have distance or fuel data
    double distanceKm = trip.distanceKm ?? 10.0;
    double fuelUsedL = trip.fuelUsedL ?? (distanceKm * 0.08); // Assume 8L/100km
    
    // Calculate savings based on eco-score
    // Better eco-score = more savings (linear relationship for simplicity)
    double savingsPercentage = (ecoScore / 100) * 0.2; // Up to 20% savings at 100 score
    
    // Fuel saved
    double fuelSaved = fuelUsedL * savingsPercentage;
    
    // CO2 reduced (approx. 2.3kg CO2 per liter of gasoline)
    double co2Reduced = fuelSaved * 2.3;
    
    // Money saved (assume $1.50 per liter - this would vary by location)
    double moneySaved = fuelSaved * 1.50;
    
    return {
      'fuelSaved': fuelSaved,
      'co2Reduced': co2Reduced,
      'moneySaved': moneySaved,
    };
  }
} 