import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/services/driving/driving_service.dart';
import 'package:going50/services/permission_service.dart';
import 'package:going50/services/service_locator.dart';

/// A large circular button that starts a trip recording.
///
/// Changes appearance based on the current driving status and 
/// provides appropriate feedback when pressed.
class StartTripButton extends StatelessWidget {
  /// The size of the button in diameter (dp)
  final double size;
  
  /// Optional callback for when the button is pressed
  /// Should return a Future to allow awaiting its completion
  final Future<void> Function()? onBeforeStart;

  /// Constructor
  const StartTripButton({
    super.key, 
    this.size = 80, 
    this.onBeforeStart,
  });

  @override
  Widget build(BuildContext context) {
    final drivingProvider = Provider.of<DrivingProvider>(context);
    final drivingStatus = drivingProvider.drivingStatus;
    final bool isRecording = drivingProvider.isRecording;
    
    // Determine if the button should be enabled
    bool isEnabled = drivingStatus == DrivingStatus.ready;
    
    // Don't log during build - can cause issues with setState during build
    // print('StartTripButton: status=$drivingStatus, isEnabled=$isEnabled, isRecording=$isRecording, isCollecting=${drivingProvider.isCollecting}, isObdConnected=${drivingProvider.isObdConnected}');
    
    // Handle button press
    void onPressed() async {
      if (!isEnabled) {
        // If a trip is already in progress, navigate to active drive screen
        if (isRecording) {
          Navigator.of(context).pushNamed(DriveRoutes.activeDrive);
          return;
        }
        
        // Otherwise show a snackbar with explanation if button is disabled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot start trip. Please check connection status.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
      
      try {
        // Get permission service
        final permissionService = serviceLocator<PermissionService>();
        
        // Check if permissions are already granted
        bool hasAllPermissions = await permissionService.areAllPermissionsGranted();
        
        // Only show the permission explanation dialog if permissions aren't already granted
        if (!hasAllPermissions && context.mounted) {
          // Call the optional callback before starting the trip
          if (onBeforeStart != null) {
            await onBeforeStart!();
          }
          
          // This will ensure we don't proceed until the explanation dialog is closed
          await Future.delayed(Duration.zero);
          
          // Request permissions separately and wait for each one
          if (context.mounted) {
            // Request location permissions first
            await permissionService.requestLocationPermissions();
            
            // Request Bluetooth permissions if needed
            if (drivingProvider.isObdConnected) {
              await permissionService.requestBluetoothPermissions();
            }
            
            // Request activity recognition permission
            await permissionService.requestActivityRecognitionPermission();
            
            // Check if all required permissions are granted
            hasAllPermissions = await permissionService.areAllPermissionsGranted();
          }
        }
        
        // Only proceed if permissions are granted and context is still valid
        if (hasAllPermissions && context.mounted) {
          // Start the trip, skipping permission checks since we've already done them
          final success = await drivingProvider.startTrip(skipPermissionChecks: true);
          
          if (success && context.mounted) {
            // Navigate to active drive screen when trip starts successfully
            Navigator.of(context).pushNamed(DriveRoutes.activeDrive);
          } else if (!success && context.mounted) {
            // Show error snackbar if trip start failed
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to start trip. Please try again.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else if (!hasAllPermissions && context.mounted) {
          // Show error message if permissions were denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot start trip without required permissions.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // Handle exceptions from the permission flow, like when user cancels the permission dialog
        if (context.mounted) {
          // Only show a message if the exception wasn't about user cancellation
          if (!e.toString().contains('canceled by user')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Trip start canceled: ${e.toString()}'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: isEnabled ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ] : [],
      ),
      child: Material(
        color: isEnabled ? AppColors.primary : AppColors.neutralGray,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: Colors.white24,
          child: Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: size / 2,
            ),
          ),
        ),
      ),
    );
  }
} 