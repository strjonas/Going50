import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/services/user/privacy_service.dart';
import 'package:going50/core_models/data_privacy_settings.dart';

/// A visual representation of what data is collected and how it's used
///
/// This component provides:
/// - Visual representation of data types collected
/// - Indication of how each data type is used
/// - Privacy score summary
class DataCollectionVisualization extends StatelessWidget {
  const DataCollectionVisualization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final privacyService = Provider.of<PrivacyService>(context, listen: false);
    
    return StreamBuilder<Map<String, DataPrivacySettings>>(
      stream: privacyService.privacySettingsStream,
      initialData: privacyService.privacySettings,
      builder: (context, snapshot) {
        final privacySettings = snapshot.data ?? {};
        
        // Calculate privacy score (0-100) based on privacy settings
        // The more restrictive the settings, the higher the score
        final privacyScore = _calculatePrivacyScore(privacySettings);
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Data Collection Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildPrivacyScoreBadge(privacyScore),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'This visualization shows what data is collected and how it\'s used.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildDataTypeRows(privacySettings),
              ],
            ),
          ),
        );
      }
    );
  }
  
  /// Calculates a privacy score from 0-100 based on privacy settings
  int _calculatePrivacyScore(Map<String, DataPrivacySettings> privacySettings) {
    if (privacySettings.isEmpty) {
      return 50; // Default middle score
    }
    
    int totalOptions = 0;
    int restrictedOptions = 0;
    
    // Count all privacy options and how many are restricted
    privacySettings.forEach((dataType, settings) {
      // Ignore local storage in score as it's required for app functionality
      totalOptions += 3; 
      
      if (settings.allowCloudSync == false) restrictedOptions++;
      if (settings.allowSharing == false) restrictedOptions++;
      if (settings.allowAnonymizedAnalytics == false) restrictedOptions++;
    });
    
    if (totalOptions == 0) return 50;
    
    // Calculate score: 50 (neutral) + up to 50 for restrictions
    return 50 + ((restrictedOptions / totalOptions) * 50).round();
  }
  
  /// Builds the privacy score badge
  Widget _buildPrivacyScoreBadge(int score) {
    // Determine color based on score
    Color color;
    if (score >= 75) {
      color = Colors.green;
    } else if (score >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds rows for each data type
  Widget _buildDataTypeRows(Map<String, DataPrivacySettings> privacySettings) {
    final List<Widget> rows = [];
    
    // Define data types and their descriptions
    final dataTypes = {
      PrivacyService.dataTypeTrips: 'Trip Data',
      PrivacyService.dataTypeLocation: 'Location Data',
      PrivacyService.dataTypeDrivingEvents: 'Driving Events',
      PrivacyService.dataTypePerformanceMetrics: 'Performance Metrics',
    };
    
    dataTypes.forEach((dataType, label) {
      final settings = privacySettings[dataType];
      
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              if (settings != null) ...[
                _buildIndicator(
                  settings.allowLocalStorage, 
                  'Local', 
                  'Stored on your device'
                ),
                const SizedBox(width: 8),
                _buildIndicator(
                  settings.allowCloudSync, 
                  'Cloud', 
                  'Synced to the cloud'
                ),
                const SizedBox(width: 8),
                _buildIndicator(
                  settings.allowSharing, 
                  'Shared', 
                  'Shared with friends'
                ),
                const SizedBox(width: 8),
                _buildIndicator(
                  settings.allowAnonymizedAnalytics, 
                  'Analytics', 
                  'Used for anonymous analytics'
                ),
              ] else ...[
                const Expanded(
                  flex: 7,
                  child: Text('Settings not configured', 
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
    
    return Column(children: rows);
  }
  
  /// Builds an indicator for a privacy setting
  Widget _buildIndicator(bool isEnabled, String label, String tooltip) {
    return Expanded(
      flex: 2,
      child: Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(
            color: isEnabled 
                ? Colors.green.withOpacity(0.2) 
                : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isEnabled ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isEnabled ? Colors.green.shade800 : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 