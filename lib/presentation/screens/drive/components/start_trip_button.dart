import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/services/driving/driving_service.dart';

/// A large circular button that starts a trip recording.
///
/// Changes appearance based on the current driving status and 
/// provides appropriate feedback when pressed.
class StartTripButton extends StatelessWidget {
  /// The size of the button in diameter (dp)
  final double size;
  
  /// Optional callback for when the button is pressed
  final VoidCallback? onBeforeStart;

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
      
      // Call the optional callback before starting the trip
      if (onBeforeStart != null) {
        onBeforeStart!();
      }
      
      // Start the trip
      final success = await drivingProvider.startTrip();
      
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