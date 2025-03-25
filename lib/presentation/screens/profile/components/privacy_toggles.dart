import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/services/user/privacy_service.dart';
import 'package:going50/core_models/data_privacy_settings.dart';

/// A component that provides toggle controls for different data types and privacy operations
///
/// This widget displays toggles for controlling:
/// - What data is collected
/// - How data is shared
/// - What operations are allowed on the data
class PrivacyToggles extends StatelessWidget {
  /// Callback for when a setting is changed
  final Function(String dataType, String operation, bool value) onSettingChanged;

  const PrivacyToggles({
    Key? key,
    required this.onSettingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final privacyService = Provider.of<PrivacyService>(context, listen: false);
    
    return StreamBuilder<Map<String, DataPrivacySettings>>(
      stream: privacyService.privacySettingsStream,
      initialData: privacyService.privacySettings,
      builder: (context, snapshot) {
        final settings = snapshot.data ?? {};
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataTypeSection(
                  context, 
                  PrivacyService.dataTypeTrips, 
                  'Trip Data',
                  'Control how your trip information is stored and shared',
                  settings[PrivacyService.dataTypeTrips],
                ),
                const Divider(),
                _buildDataTypeSection(
                  context, 
                  PrivacyService.dataTypeLocation, 
                  'Location Data',
                  'Control how your location information is stored and shared',
                  settings[PrivacyService.dataTypeLocation],
                ),
                const Divider(),
                _buildDataTypeSection(
                  context, 
                  PrivacyService.dataTypeDrivingEvents, 
                  'Driving Events',
                  'Control how specific driving behaviors are recorded and shared',
                  settings[PrivacyService.dataTypeDrivingEvents],
                ),
                const Divider(),
                _buildDataTypeSection(
                  context, 
                  PrivacyService.dataTypePerformanceMetrics, 
                  'Performance Metrics',
                  'Control how your eco-driving performance is analyzed and shared',
                  settings[PrivacyService.dataTypePerformanceMetrics],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  
  /// Builds a section for controlling a specific data type
  Widget _buildDataTypeSection(
    BuildContext context,
    String dataType,
    String title,
    String description,
    dynamic settings,
  ) {
    final isConfigured = settings != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        if (isConfigured) ...[
          _buildToggleItem(
            context,
            'Store on Device',
            'Required for app functionality',
            settings.allowLocalStorage,
            (value) => onSettingChanged(dataType, PrivacyService.operationLocalStorage, value),
            isEnabled: false, // Local storage is required, so disable this toggle
          ),
          _buildToggleItem(
            context,
            'Sync to Cloud',
            'Upload data to your account in the cloud',
            settings.allowCloudSync,
            (value) => onSettingChanged(dataType, PrivacyService.operationCloudSync, value),
          ),
          _buildToggleItem(
            context,
            'Share with Friends',
            'Allow friends to see this data',
            settings.allowSharing,
            (value) => onSettingChanged(dataType, PrivacyService.operationSharing, value),
          ),
          _buildToggleItem(
            context,
            'Anonymous Analytics',
            'Contribute to improving the app (no personal data)',
            settings.allowAnonymizedAnalytics,
            (value) => onSettingChanged(dataType, PrivacyService.operationAnalytics, value),
          ),
        ] else ...[
          const Center(
            child: Text(
              'Settings not configured',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  /// Builds a toggle item with label and description
  Widget _buildToggleItem(
    BuildContext context,
    String label,
    String description,
    bool value,
    Function(bool) onChanged, {
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isEnabled ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isEnabled ? Colors.grey : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: isEnabled ? onChanged : null,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
} 