import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/theme/app_colors.dart';
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
    
    // Handle button press
    void onPressed() async {
      if (!isEnabled) {
        // Show a snackbar with explanation if button is disabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isRecording 
              ? 'Trip already in progress. Go to the active driving screen.' 
              : 'Cannot start trip. Please check connection status.'),
            duration: const Duration(seconds: 3),
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
      
      if (!success && context.mounted) {
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