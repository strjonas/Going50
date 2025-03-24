import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/providers/driving_provider.dart';

/// A widget that displays the current connection status.
///
/// Shows whether the app is connected to an OBD device or using phone sensors,
/// with appropriate styling and messaging.
class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final drivingProvider = Provider.of<DrivingProvider>(context);
    final isObdConnected = drivingProvider.isObdConnected;
    final isCollecting = drivingProvider.isCollecting;
    final preferOBD = drivingProvider.preferOBD;
    
    // Determine status text and styling based on connection state
    String statusText;
    IconData iconData;
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    
    if (isObdConnected) {
      statusText = 'OBD Connected';
      iconData = Icons.bluetooth_connected;
      backgroundColor = AppColors.success.withOpacity(0.1);
      borderColor = AppColors.success;
      textColor = AppColors.success;
    } else if (isCollecting) {
      statusText = 'Using Phone Sensors';
      iconData = Icons.phone_android;
      backgroundColor = AppColors.warning.withOpacity(0.1);
      borderColor = AppColors.warning;
      textColor = AppColors.warning;
    } else if (preferOBD) {
      statusText = 'OBD Not Connected';
      iconData = Icons.bluetooth_disabled;
      backgroundColor = AppColors.neutralGray.withOpacity(0.1);
      borderColor = AppColors.neutralGray;
      textColor = AppColors.neutralGray;
    } else {
      statusText = 'Sensors Ready';
      iconData = Icons.sensors;
      backgroundColor = AppColors.neutralGray.withOpacity(0.1);
      borderColor = AppColors.neutralGray;
      textColor = AppColors.neutralGray;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: textColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
} 