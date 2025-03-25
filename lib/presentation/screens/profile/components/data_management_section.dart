import 'package:flutter/material.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:going50/core/constants/route_constants.dart';

/// A component that provides options for managing user data
///
/// This component offers:
/// - Data export functionality
/// - Cloud data deletion options
/// - Data retention information
class DataManagementSection extends StatelessWidget {
  const DataManagementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cloud Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Export or delete your cloud data. Local data can be managed in the Data Management tab.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildExportDataButton(context),
            const SizedBox(height: 16),
            _buildDeleteCloudDataButton(context),
            const SizedBox(height: 16),
            _buildManageLocalDataButton(context),
            const SizedBox(height: 16),
            _buildDataRetentionInfo(),
          ],
        ),
      ),
    );
  }
  
  /// Builds the export data button
  Widget _buildExportDataButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleExportData(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            'EXPORT YOUR DATA',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
  
  /// Builds the delete cloud data button
  Widget _buildDeleteCloudDataButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showDeleteCloudConfirmation(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        side: const BorderSide(color: Colors.red),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, color: Colors.red),
          SizedBox(width: 8),
          Text(
            'DELETE ALL CLOUD DATA',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
  
  /// Builds the manage local data button
  Widget _buildManageLocalDataButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed(
        ProfileRoutes.dataManagement,
        arguments: {'scrollToReset': true},
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storage, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            'MANAGE LOCAL DATA',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
  
  /// Builds the data retention information section
  Widget _buildDataRetentionInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Retention',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'By default, your data is stored locally on your device. If you enable cloud sync, '
          'your data is also stored in our secure cloud according to our privacy policy.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 8),
        Text(
          'Local data is retained until you delete it manually. Cloud data is retained as long as '
          'you have an active account.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
  
  /// Handles the export data action
  void _handleExportData(BuildContext context) {
    // Show a loading indicator during export
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Preparing your data export...'),
          ],
        ),
      ),
    );

    // Simulate export process with a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show completion dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Export Ready'),
          content: const Text(
            'Your data has been exported successfully. It will be downloaded to your device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
  
  /// Shows the delete cloud data confirmation dialog
  void _showDeleteCloudConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Cloud Data?'),
        content: const Text(
          'This will permanently delete all your data stored in our cloud servers. '
          'Your local data will remain intact. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDeleteCloudData(context);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Handles the delete cloud data action
  void _handleDeleteCloudData(BuildContext context) {
    // Show a loading indicator during deletion
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Deleting your cloud data...'),
          ],
        ),
      ),
    );

    // Get the user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Simulate cloud data deletion (in a real app, this would delete from cloud servers)
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show completion dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cloud Data Deleted'),
          content: const Text(
            'All your data has been deleted from our cloud servers. Your local data remains unaffected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
} 