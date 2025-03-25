import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/widgets/common/indicators/status_indicator.dart';
import 'package:going50/presentation/widgets/common/buttons/primary_button.dart';

/// A widget that manages the currently connected OBD device
/// and provides options to disconnect or reconnect.
class ConnectionManager extends StatefulWidget {
  /// Called when disconnection is successful
  final VoidCallback onDisconnected;

  /// Constructor
  const ConnectionManager({
    super.key,
    required this.onDisconnected,
  });

  @override
  State<ConnectionManager> createState() => _ConnectionManagerState();
}

class _ConnectionManagerState extends State<ConnectionManager> {
  bool _isDisconnecting = false;
  String? _errorMessage;
  BluetoothDevice? _connectedDevice;

  @override
  void initState() {
    super.initState();
    _updateConnectedDevice();
  }

  /// Updates the connected device information
  void _updateConnectedDevice() {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    // In a real implementation, we would query the connected device details
    // from the ObdConnectionService. For now, we'll use basic info.
    if (drivingProvider.isObdConnected) {
      setState(() {
        _connectedDevice = BluetoothDevice(
          id: 'unknown', // We don't have direct access to the device ID
          name: 'Connected OBD Device',
          rssi: 0,
        );
      });
    } else {
      setState(() {
        _connectedDevice = null;
      });
    }
  }

  /// Disconnects from the current OBD device
  Future<void> _disconnectDevice() async {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    setState(() {
      _isDisconnecting = true;
      _errorMessage = null;
    });

    try {
      await drivingProvider.disconnectObdDevice();
      
      setState(() {
        _isDisconnecting = false;
        _connectedDevice = null;
      });
      
      widget.onDisconnected();
    } catch (e) {
      setState(() {
        _isDisconnecting = false;
        _errorMessage = 'Failed to disconnect: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final drivingProvider = Provider.of<DrivingProvider>(context);
    final isConnected = drivingProvider.isObdConnected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Connected Device',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        
        const SizedBox(height: 16),
        
        // Status
        if (isConnected && _connectedDevice != null) ...[
          _buildConnectedDeviceCard(),
        ] else ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusIndicator(
                text: 'No device connected',
                type: StatusType.inactive,
                icon: Icons.bluetooth_disabled,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary.withAlpha(40),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Go to "Available Devices" below to scan and connect to your OBD adapter',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        
        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          StatusIndicator(
            text: _errorMessage!,
            type: StatusType.error,
            icon: Icons.error_outline,
          ),
        ],
      ],
    );
  }

  /// Builds the connected device card
  Widget _buildConnectedDeviceCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection status
          Row(
            children: [
              StatusIndicator(
                text: 'Connected',
                type: StatusType.success,
                icon: Icons.bluetooth_connected,
              ),
              const Spacer(),
              if (_isDisconnecting)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Device info
          Row(
            children: [
              const Icon(Icons.bluetooth, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _connectedDevice?.name ?? 'Unknown Device',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _connectedDevice?.id ?? 'Unknown ID',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Disconnect button
          PrimaryButton(
            text: 'Disconnect',
            icon: Icons.bluetooth_disabled,
            onPressed: _isDisconnecting ? null : _disconnectDevice,
          ),
        ],
      ),
    );
  }
} 