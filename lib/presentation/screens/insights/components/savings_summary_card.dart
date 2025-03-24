import 'package:flutter/material.dart';
import 'package:going50/core/utils/formatter_utils.dart';

/// A card displaying the estimated savings from eco-driving
///
/// This card shows the estimated savings in fuel, money, and CO2 emissions
/// compared to baseline driving behaviors.
class SavingsSummaryCard extends StatelessWidget {
  /// Estimated fuel savings in liters
  final double fuelSavingsL;
  
  /// Estimated money savings in the user's currency (assumed to be USD for now)
  final double moneySavings;
  
  /// Estimated CO2 reduction in kg
  final double co2ReductionKg;
  
  /// Time period description (e.g., "This Week", "This Month")
  final String timePeriod;
  
  /// Constructor
  const SavingsSummaryCard({
    super.key,
    required this.fuelSavingsL,
    required this.moneySavings,
    required this.co2ReductionKg,
    required this.timePeriod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.savings_outlined,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Savings $timePeriod',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSavingItem(
                context,
                icon: Icons.local_gas_station,
                value: FormatterUtils.formatFuel(fuelSavingsL),
                label: 'Fuel',
                iconColor: Colors.orange,
              ),
              _buildSavingItem(
                context,
                icon: Icons.attach_money,
                value: FormatterUtils.formatCurrency(moneySavings),
                label: 'Money',
                iconColor: Colors.green,
              ),
              _buildSavingItem(
                context,
                icon: Icons.co2,
                value: '${FormatterUtils.formatDistance(co2ReductionKg, includeUnit: false)} kg',
                label: 'CO₂',
                iconColor: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Based on your eco-driving compared to average driving patterns',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds a single saving metric item
  Widget _buildSavingItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(51), // ~20% opacity
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
} 