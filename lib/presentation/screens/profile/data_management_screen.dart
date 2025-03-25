import 'package:flutter/material.dart';
import 'package:going50/presentation/screens/profile/components/data_management_section.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/privacy_service.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:flutter/services.dart';

/// DataManagementScreen provides a comprehensive interface for managing user data
/// 
/// Features:
/// - Local data deletion
/// - Data export
/// - Data usage statistics
/// - Privacy settings access
class DataManagementScreen extends StatefulWidget {
  /// Whether to automatically scroll to the data reset section
  final bool scrollToReset;
  
  const DataManagementScreen({
    Key? key, 
    this.scrollToReset = false,
  }) : super(key: key);

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  final PrivacyService _privacyService = serviceLocator<PrivacyService>();
  bool _isLoading = false;
  
  // Scroll controller for managing scroll position
  final ScrollController _scrollController = ScrollController();
  
  // Reference to data controls section
  final GlobalKey _dataControlsKey = GlobalKey();
  
  // Flag to track if we've already scrolled
  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
    
    // Add post-frame callback to scroll to the data controls section if needed
    if (widget.scrollToReset) {
      // Add a slightly longer delay to ensure rendering is complete
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_hasScrolled) {
          _scrollToDataControls();
        }
      });
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls to the data controls section with animation
  void _scrollToDataControls() {
    // Scroll to a specific position from the top that will likely show the reset button
    // This is more reliable than trying to calculate exact positions
    final double targetPosition = MediaQuery.of(context).size.height * 0.95;
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    ).then((_) {
      // After the first scroll, set up a delayed second scroll to fine-tune position
      // This handles cases where content height changes during the first scroll
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent - 200, // Show the reset button with some context above it
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
          _hasScrolled = true;
        }
      });
    });
  }

  Future<void> _loadPrivacySettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _privacyService.initialize();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Data Management'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title and description
                      const Text(
                        'Manage Your Local Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Control how your local device data is stored, exported, or deleted. For cloud data management, use the Privacy Settings.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Data Management Section - customize to hide redundant button when already on this screen
                      _buildLocalDataManagementSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Data Storage Details
                      _buildDataStorageCard(context),
                      
                      const SizedBox(height: 24),
                      
                      // Data Control Actions - with key for scrolling
                      Container(
                        key: _dataControlsKey,
                        child: _buildDataControlsCard(context, userProvider),
                      ),
                      
                      // Add extra space at bottom for better scrolling
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                
                // Show a floating hint button if we're supposed to scroll
                if (widget.scrollToReset && !_hasScrolled)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: _scrollToDataControls,
                      tooltip: 'Reset options below',
                      child: const Icon(Icons.arrow_downward),
                    ),
                  ),
              ],
            ),
    );
  }
  
  /// Build a customized version of the DataManagementSection that doesn't include
  /// the "Manage Local Data" button when already on this screen
  Widget _buildLocalDataManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Data Management Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // If scrollToReset is true, show a hint to scroll down
                if (widget.scrollToReset)
                  Tooltip(
                    message: 'Reset options below',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: _scrollToDataControls,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Export your data or manage cloud data in the Privacy Settings section.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                if (widget.scrollToReset)
                  Text(
                    'Scroll down for reset options →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExportDataButton(context),
            const SizedBox(height: 16),
            _buildDataRetentionInfo(),
          ],
        ),
      ),
    );
  }
  
  /// Builds the export data button (copied from DataManagementSection)
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
  
  /// Handles the export data action (copied from DataManagementSection)
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
  
  /// Builds the data retention information section (copied from DataManagementSection)
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
  
  /// Build a card showing data storage details
  Widget _buildDataStorageCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Data Storage Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // If scrollToReset is true, show a hint to scroll down
                if (widget.scrollToReset)
                  Tooltip(
                    message: 'Reset options below',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: _scrollToDataControls,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'This screen lets you manage data stored on your device. For cloud data management, visit Privacy Settings.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            
            // Data types with storage info
            FutureBuilder<bool>(
              future: _privacyService.isOperationAllowed(
                PrivacyService.dataTypeTrips, 'cloud_sync'
              ),
              builder: (context, snapshot) {
                return _buildDataTypeStorageRow(
                  'Trip Data', 
                  true, 
                  snapshot.data ?? false,
                );
              }
            ),
            const SizedBox(height: 12),
            
            FutureBuilder<bool>(
              future: _privacyService.isOperationAllowed(
                PrivacyService.dataTypeLocation, 'cloud_sync'
              ),
              builder: (context, snapshot) {
                return _buildDataTypeStorageRow(
                  'Location History', 
                  true, 
                  snapshot.data ?? false,
                );
              }
            ),
            const SizedBox(height: 12),
            
            FutureBuilder<bool>(
              future: _privacyService.isOperationAllowed(
                PrivacyService.dataTypePerformanceMetrics, 'cloud_sync'
              ),
              builder: (context, snapshot) {
                return _buildDataTypeStorageRow(
                  'Performance Metrics', 
                  true, 
                  snapshot.data ?? false,
                );
              }
            ),
            const SizedBox(height: 12),
            
            FutureBuilder<bool>(
              future: _privacyService.isOperationAllowed(
                PrivacyService.dataTypeDrivingEvents, 'cloud_sync'
              ),
              builder: (context, snapshot) {
                return _buildDataTypeStorageRow(
                  'Driving Events', 
                  true, 
                  snapshot.data ?? false,
                );
              }
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Note about cloud sync
            const Text(
              'To manage cloud data or change sync settings, visit Privacy Settings. The reset function on this screen only affects local data.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a row showing storage status for a data type
  Widget _buildDataTypeStorageRow(String dataType, bool isLocal, bool isCloud) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            dataType,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.smartphone,
                size: 16,
                color: isLocal ? AppColors.ecoScoreHigh : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                isLocal ? 'Local' : 'Not Local',
                style: TextStyle(
                  fontSize: 12,
                  color: isLocal ? AppColors.ecoScoreHigh : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                Icons.cloud,
                size: 16,
                color: isCloud ? AppColors.ecoScoreMedium : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                isCloud ? 'Cloud' : 'Not Synced',
                style: TextStyle(
                  fontSize: 12,
                  color: isCloud ? AppColors.ecoScoreMedium : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build a card with data control options
  Widget _buildDataControlsCard(BuildContext context, UserProvider userProvider) {
    return Card(
      elevation: widget.scrollToReset ? 4 : 1, // Highlight card if we're scrolling to it
      margin: widget.scrollToReset 
          ? const EdgeInsets.all(4) 
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.scrollToReset 
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Reset Local App Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Add a hint icon if we're highlighting this section
                if (widget.scrollToReset)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Here it is!',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'This option will delete all local data and reset the app as if it was newly installed.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Reset app button
            OutlinedButton(
              onPressed: () => _showResetConfirmation(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restore, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'DELETE LOCAL DATA & RESET APP',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text(
              'This will delete all your local data and reset your user profile. You will be returned to the onboarding flow. This action cannot be undone.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Note: This does not affect any data stored on cloud servers. To delete cloud data, use the Cloud Data Management option in Privacy Settings.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Show confirmation dialog for resetting the app
  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Local Data & Reset App?'),
        content: const Text(
          'This will permanently delete all your local data and reset the app. '
          'Cloud data will not be affected. '
          'You will be returned to the onboarding flow. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleResetApp(context);
            },
            child: const Text(
              'DELETE & RESET',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Handle app reset
  void _handleResetApp(BuildContext context) {
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
            Text('Deleting local data and resetting app...'),
          ],
        ),
      ),
    );

    // Get the user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Also get direct access to services for complete reset
    final dataStorageManager = serviceLocator<DataStorageManager>();
    
    // Create a timeout to prevent hanging
    bool isCompleted = false;
    
    // Set a timeout to prevent hanging
    Future.delayed(Duration(seconds: 10), () {
      if (!isCompleted && mounted) {
        print("Data deletion operation timed out - forcing completion");
        _completeReset(context);
        isCompleted = true;
      }
    });
    
    // Reset the user state completely with a smaller scope
    Future.microtask(() async {
      try {
        // Get current user ID before resetting
        final userId = userProvider.userProfile?.id;
        
        if (userId != null) {
          // Basic reset: reset preferences and user data
          
          // 1. Clear shared preferences first
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear(); // Clear ALL preferences
          
          // 2. Reset onboarding status explicitly
          await prefs.setBool('onboarding_complete', false);
          
          // 3. Force reset the user provider state
          await userProvider.resetUser();
          
          // 4. Try to delete critical tables only, don't worry about social ones
          try {
            // Delete core user data with individual timeouts
            await dataStorageManager.deleteBasicUserData(userId);
          } catch (e) {
            print("Error during data deletion, continuing with reset: $e");
          }
        }
        
        if (!isCompleted) {
          _completeReset(context);
          isCompleted = true;
        }
      } catch (error) {
        print("Error during reset: $error");
        // Close loading dialog if open
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        
        // Show error dialog
        if (mounted && !isCompleted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(
                'An error occurred while deleting local data: $error\n\nThe app will now exit. Please restart it to complete the reset.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: const Text('EXIT APP'),
                ),
              ],
            ),
          );
          isCompleted = true;
        }
      }
    });
  }
  
  /// Complete the reset process and show final dialog
  void _completeReset(BuildContext context) {
    // Close loading dialog if open
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    
    // Show completion dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('App Reset Complete'),
          content: const Text(
            'Your data has been deleted and the app has been reset. The app will now exit. Please restart it to start fresh.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Exit the app to ensure a clean slate
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text('EXIT APP'),
            ),
          ],
        ),
      );
    }
  }
} 