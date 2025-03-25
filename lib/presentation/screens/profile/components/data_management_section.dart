import 'package:flutter/material.dart';

/// A component that provides options for managing user data
///
/// This component offers:
/// - Data export functionality
/// - Data deletion options
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
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Export or delete your data. Exported data will be available as a JSON file.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildExportDataButton(context),
            const SizedBox(height: 16),
            _buildDeleteDataButton(context),
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
  
  /// Builds the delete data button
  Widget _buildDeleteDataButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showDeleteConfirmation(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        side: const BorderSide(color: Colors.red),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 8),
          Text(
            'DELETE ALL DATA',
            style: TextStyle(color: Colors.red),
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
  
  /// Shows the delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data?'),
        content: const Text(
          'This will permanently delete all your data stored in this app. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDeleteData(context);
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
  
  /// Handles the delete data action
  void _handleDeleteData(BuildContext context) {
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
            Text('Deleting your data...'),
          ],
        ),
      ),
    );

    // Simulate deletion process with a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show completion dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Deleted'),
          content: const Text(
            'All your data has been permanently deleted.',
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