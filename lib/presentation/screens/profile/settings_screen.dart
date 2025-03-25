import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/screens/profile/components/settings_section.dart';
import 'package:going50/presentation/screens/profile/components/settings_item.dart';

/// The Settings Screen for the Going50 app.
///
/// This screen displays all app configuration options organized by category.
class SettingsScreen extends StatelessWidget {
  /// Constructor for the settings screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isAnonymous = userProvider.isAnonymous;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Account Section (if signed in)
            if (!isAnonymous) _buildAccountSection(context, userProvider),
            
            // Privacy Section
            _buildPrivacySection(context, userProvider),
            
            // Device Section
            _buildDeviceSection(context, userProvider),
            
            // Preferences Section
            _buildPreferencesSection(context, userProvider),
            
            // About Section
            _buildAboutSection(context, userProvider),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Builds the account section of settings.
  Widget _buildAccountSection(BuildContext context, UserProvider userProvider) {
    return SettingsSection(
      title: 'ACCOUNT',
      children: [
        SettingsItem(
          title: 'Profile Information',
          subtitle: userProvider.userProfile?.name ?? 'Your profile details',
          icon: Icons.person,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to profile edit screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile edit not yet implemented'),
              ),
            );
          },
        ),
        SettingsItem(
          title: 'Data Sync',
          subtitle: userProvider.getPreference('privacy', 'allow_data_upload') == true
              ? 'Enabled'
              : 'Disabled',
          icon: Icons.sync,
          trailing: Switch(
            value: userProvider.getPreference('privacy', 'allow_data_upload') == true,
            onChanged: (value) async {
              await userProvider.updatePreference('privacy', 'allow_data_upload', value);
            },
          ),
          onTap: null, // Tapping the row doesn't do anything since we have a switch
        ),
        SettingsItem(
          title: 'Delete Account',
          subtitle: 'Permanently delete your account and all data',
          icon: Icons.delete_forever,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          showDivider: false,
          onTap: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Account?'),
                content: const Text(
                  'This will permanently delete your account and all associated data. This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: Implement account deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account deletion not yet implemented'),
                        ),
                      );
                    },
                    child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds the privacy section of settings.
  Widget _buildPrivacySection(BuildContext context, UserProvider userProvider) {
    return SettingsSection(
      title: 'PRIVACY',
      children: [
        SettingsItem(
          title: 'Privacy Settings',
          subtitle: 'Data collection and sharing preferences',
          icon: Icons.privacy_tip,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.of(context).pushNamed(ProfileRoutes.privacySettings);
          },
        ),
        SettingsItem(
          title: 'Social Visibility',
          subtitle: userProvider.getPreference('privacy', 'share_achievements') == true
              ? 'Public profile'
              : 'Private profile',
          icon: Icons.visibility,
          trailing: Switch(
            value: userProvider.getPreference('privacy', 'share_achievements') == true,
            onChanged: (value) async {
              await userProvider.updatePreference('privacy', 'share_achievements', value);
            },
          ),
          onTap: null,
        ),
        SettingsItem(
          title: 'Data Management',
          subtitle: 'Export or delete your data',
          icon: Icons.storage,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          showDivider: false,
          onTap: () {
            // Navigate to data management screen without scrolling to reset
            Navigator.of(context).pushNamed(
              ProfileRoutes.dataManagement,
              arguments: {'scrollToReset': false},
            );
          },
        ),
      ],
    );
  }

  /// Builds the device section of settings.
  Widget _buildDeviceSection(BuildContext context, UserProvider userProvider) {
    final connectionMode = userProvider.getPreference('connection', 'connection_mode') as String? ?? 'auto';
    
    String connectionModeText;
    switch (connectionMode) {
      case 'auto':
        connectionModeText = 'Automatic (OBD if available)';
        break;
      case 'obd_only':
        connectionModeText = 'OBD device only';
        break;
      case 'phone_only':
        connectionModeText = 'Phone sensors only';
        break;
      default:
        connectionModeText = 'Automatic';
    }
    
    return SettingsSection(
      title: 'DEVICE',
      children: [
        SettingsItem(
          title: 'OBD Connection',
          subtitle: 'Manage connected OBD devices',
          icon: Icons.bluetooth,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.of(context).pushNamed(ProfileRoutes.deviceConnection);
          },
        ),
        SettingsItem(
          title: 'Connection Mode',
          subtitle: connectionModeText,
          icon: Icons.settings_input_component,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showConnectionModeDialog(context, userProvider, connectionMode);
          },
        ),
        SettingsItem(
          title: 'Background Operation',
          subtitle: userProvider.getPreference('driving', 'auto_end_trip') == true
              ? 'Enabled'
              : 'Disabled',
          icon: Icons.directions_car,
          trailing: Switch(
            value: userProvider.getPreference('driving', 'auto_end_trip') == true,
            onChanged: (value) async {
              await userProvider.updatePreference('driving', 'auto_end_trip', value);
            },
          ),
          showDivider: false,
          onTap: null,
        ),
      ],
    );
  }

  /// Builds the preferences section of settings.
  Widget _buildPreferencesSection(BuildContext context, UserProvider userProvider) {
    final units = userProvider.getPreference('display', 'units') as String? ?? 'metric';
    
    return SettingsSection(
      title: 'PREFERENCES',
      children: [
        SettingsItem(
          title: 'Notification Settings',
          subtitle: 'Customize app notifications',
          icon: Icons.notifications,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to notification settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification settings not yet implemented'),
              ),
            );
          },
        ),
        SettingsItem(
          title: 'Display Preferences',
          subtitle: 'Theme and display options',
          icon: Icons.palette,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to display settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Display settings not yet implemented'),
              ),
            );
          },
        ),
        SettingsItem(
          title: 'Audio Feedback',
          subtitle: userProvider.getPreference('driving', 'audio_feedback') == true
              ? 'Enabled'
              : 'Disabled',
          icon: Icons.volume_up,
          trailing: Switch(
            value: userProvider.getPreference('driving', 'audio_feedback') == true,
            onChanged: (value) async {
              await userProvider.updatePreference('driving', 'audio_feedback', value);
            },
          ),
          onTap: null,
        ),
        SettingsItem(
          title: 'Measurement Units',
          subtitle: units == 'metric' ? 'Metric (km, L)' : 'Imperial (mi, gal)',
          icon: Icons.straighten,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showUnitSelectionDialog(context, userProvider, units);
          },
          showDivider: false,
        ),
      ],
    );
  }

  /// Builds the about section of settings.
  Widget _buildAboutSection(BuildContext context, UserProvider userProvider) {
    return SettingsSection(
      title: 'ABOUT',
      children: [
        SettingsItem(
          title: 'App Version',
          subtitle: '1.0.0 (beta)',
          icon: Icons.info,
          onTap: null,
        ),
        SettingsItem(
          title: 'Terms of Service',
          icon: Icons.description,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to terms of service
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Terms of service not yet implemented'),
              ),
            );
          },
        ),
        SettingsItem(
          title: 'Privacy Policy',
          icon: Icons.policy,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to privacy policy
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Privacy policy not yet implemented'),
              ),
            );
          },
        ),
        SettingsItem(
          title: 'Send Feedback',
          icon: Icons.feedback,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          showDivider: false,
          onTap: () {
            // TODO: Navigate to feedback form
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feedback form not yet implemented'),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Shows a dialog to select connection mode.
  void _showConnectionModeDialog(BuildContext context, UserProvider userProvider, String currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Automatic'),
              subtitle: const Text('Use OBD if available, fallback to phone sensors'),
              value: 'auto',
              groupValue: currentMode,
              onChanged: (value) async {
                Navigator.of(context).pop();
                await userProvider.updatePreference('connection', 'connection_mode', value);
              },
            ),
            RadioListTile<String>(
              title: const Text('OBD Only'),
              subtitle: const Text('Only use OBD device for data collection'),
              value: 'obd_only',
              groupValue: currentMode,
              onChanged: (value) async {
                Navigator.of(context).pop();
                await userProvider.updatePreference('connection', 'connection_mode', value);
              },
            ),
            RadioListTile<String>(
              title: const Text('Phone Only'),
              subtitle: const Text('Only use phone sensors for data collection'),
              value: 'phone_only',
              groupValue: currentMode,
              onChanged: (value) async {
                Navigator.of(context).pop();
                await userProvider.updatePreference('connection', 'connection_mode', value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to select measurement units.
  void _showUnitSelectionDialog(BuildContext context, UserProvider userProvider, String currentUnits) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Measurement Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Metric'),
              subtitle: const Text('Kilometers, Liters, kg CO₂'),
              value: 'metric',
              groupValue: currentUnits,
              onChanged: (value) async {
                Navigator.of(context).pop();
                await userProvider.updatePreference('display', 'units', value);
              },
            ),
            RadioListTile<String>(
              title: const Text('Imperial'),
              subtitle: const Text('Miles, Gallons, lbs CO₂'),
              value: 'imperial',
              groupValue: currentUnits,
              onChanged: (value) async {
                Navigator.of(context).pop();
                await userProvider.updatePreference('display', 'units', value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }
} 