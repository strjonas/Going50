import 'package:flutter/material.dart';

/// DriveScreen is the main screen for the Drive tab.
///
/// This screen provides access to trip recording functionality and displays
/// connection status.
class DriveScreen extends StatelessWidget {
  const DriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drive'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'Drive Tab',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Start recording your trips to improve your eco-driving score',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement trip recording functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Trip recording not yet implemented'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Start Trip',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            _buildConnectionStatus(),
          ],
        ),
      ),
    );
  }
  
  /// Builds the connection status indicator widget
  Widget _buildConnectionStatus() {
    // TODO: Implement actual connection status check
    const bool isConnected = false;
    
    final Color backgroundColor = isConnected ? Colors.green.withAlpha(26) : Colors.grey.withAlpha(26);
    final Color borderColor = isConnected ? Colors.green : Colors.grey;
    final IconData iconData = isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled;
    final String statusText = isConnected ? 'OBD Connected' : 'OBD Not Connected';
    final Color textColor = borderColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
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
            ),
          ),
        ],
      ),
    );
  }
} 