import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:going50/services/user/privacy_service.dart';
import 'package:going50/presentation/screens/profile/components/data_collection_visualization.dart';
import 'package:going50/presentation/screens/profile/components/privacy_toggles.dart';
import 'package:going50/presentation/screens/profile/components/data_management_section.dart';
import 'package:going50/core_models/data_privacy_settings.dart';

/// Privacy Settings Screen allows users to control their data collection and sharing preferences
///
/// This screen provides:
/// - Visual representation of what data is collected and how it's used
/// - Granular toggle controls for different data types
/// - Data management options (export, delete)
/// - Privacy policy information
class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _isLoading = true; // Start with loading state

  @override
  void initState() {
    super.initState();
    // Initialize privacy settings when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePrivacySettings();
    });
  }
  
  /// Initialize privacy settings
  Future<void> _initializePrivacySettings() async {
    try {
      final privacyService = Provider.of<PrivacyService>(context, listen: false);
      await privacyService.initialize();
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load privacy settings: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final privacyService = Provider.of<PrivacyService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<Map<String, DataPrivacySettings>>(
            stream: privacyService.privacySettingsStream,
            initialData: privacyService.privacySettings,
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Force refresh of privacy settings
                  setState(() => _isLoading = true);
                  await _initializePrivacySettings();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Privacy score and visualization section
                      const DataCollectionVisualization(),
                      
                      const SizedBox(height: 24),
                      
                     
                      
                      // Data collection toggles
                      const Text(
                        'Data Collection Controls',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrivacyToggles(
                        onSettingChanged: (dataType, operation, value) {
                          // Handle privacy setting changes
                          setState(() => _isLoading = true);
                          _updatePrivacySetting(dataType, operation, value).then((_) {
                            // Force screen refresh to update visualization
                            setState(() => _isLoading = false);
                          });
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Data management section
                      const DataManagementSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Privacy policy section
                      _buildPrivacyPolicySection(context),
                    ],
                  ),
                ),
              );
            }
          ),
    );
  }
  
  /// Updates a privacy setting for a data type and operation
  Future<void> _updatePrivacySetting(String dataType, String operation, bool value) async {
    try {
      final privacyService = context.read<PrivacyService>();
      
      // Determine which setting to update based on operation
      if (operation == PrivacyService.operationLocalStorage) {
        await privacyService.updatePrivacySetting(
          dataType: dataType,
          allowLocalStorage: value,
        );
      } else if (operation == PrivacyService.operationCloudSync) {
        await privacyService.updatePrivacySetting(
          dataType: dataType,
          allowCloudSync: value,
        );
      } else if (operation == PrivacyService.operationSharing) {
        await privacyService.updatePrivacySetting(
          dataType: dataType,
          allowSharing: value,
        );
      } else if (operation == PrivacyService.operationAnalytics) {
        await privacyService.updatePrivacySetting(
          dataType: dataType,
          allowAnonymizedAnalytics: value,
        );
      }
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update setting: $e')),
        );
      }
    }
  }
  
  /// Builds the privacy policy section
  Widget _buildPrivacyPolicySection(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Going50 respects your privacy and gives you full control over your data. '
              'We collect only the data you allow us to, and use it only in the ways you permit.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full privacy policy
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy policy coming soon')),
                    );
                  },
                  child: const Text('READ FULL POLICY'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}