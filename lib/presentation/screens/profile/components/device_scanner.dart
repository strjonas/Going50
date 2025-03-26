import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/widgets/common/indicators/status_indicator.dart';
import 'package:going50/presentation/widgets/common/buttons/primary_button.dart';

/// A widget that scans for OBD Bluetooth devices and displays them in a list.
class DeviceScanner extends StatefulWidget {
  /// Function called when a device is selected
  final Function(BluetoothDevice device) onDeviceSelected;

  /// Constructor
  const DeviceScanner({
    super.key,
    required this.onDeviceSelected,
  });

  @override
  State<DeviceScanner> createState() => _DeviceScannerState();
}

class _DeviceScannerState extends State<DeviceScanner> {
  bool _isScanning = false;
  List<BluetoothDevice> _devices = [];
  StreamSubscription? _scanSubscription;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Start scanning when the widget is first initialized
    _startScan();
  }

  @override
  void dispose() {
    // Cancel scan subscription when widget is disposed
    _scanSubscription?.cancel();
    super.dispose();
  }

  /// Start scanning for OBD devices
  void _startScan() {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    // Cancel any existing scan first
    _stopScan();
    
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _devices = [];
    });

    try {
      // Subscribe to device stream
      _scanSubscription = drivingProvider.scanForObdDevices().listen(
        (devices) {
          if (mounted) {
            setState(() {
              _devices = devices;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isScanning = false;
              _errorMessage = 'Failed to scan for devices: $error';
            });
          }
        },
        onDone: () {
          if (mounted) {
            setState(() {
              _isScanning = false;
            });
          }
        },
      );

      // Stop scan after 30 seconds if not already stopped
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted && _isScanning) {
          _stopScan();
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _errorMessage = 'Failed to scan for devices: $e';
        });
      }
    }
  }

  /// Stop scanning for OBD devices
  void _stopScan() {
    if (!_isScanning) return;
    
    setState(() {
      _isScanning = false;
    });

    // First cancel our subscription to prevent memory leaks
    _scanSubscription?.cancel();
    _scanSubscription = null;
    
    // Then tell the driving provider to stop scanning
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    drivingProvider.stopScanningForDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Devices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (_isScanning)
              StatusIndicator(
                text: 'Scanning...',
                type: StatusType.info,
                icon: Icons.search,
              ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Error message
        if (_errorMessage != null) ...[
          StatusIndicator(
            text: _errorMessage!,
            type: StatusType.error,
            icon: Icons.error_outline,
          ),
          const SizedBox(height: 16),
        ],
        
        // Device list
        if (_devices.isEmpty && !_isScanning)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No devices found. Make sure your OBD adapter is powered on and in pairing mode.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _devices.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(device.name.isNotEmpty ? device.name : 'Unknown Device'),
                  subtitle: Text(device.id),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    widget.onDeviceSelected(device);
                  },
                );
              },
            ),
          ),
        
        const SizedBox(height: 20),
        
        // Scan button
        Center(
          child: PrimaryButton(
            text: _isScanning ? 'Stop Scan' : 'Scan for Devices',
            icon: _isScanning ? Icons.stop : Icons.search,
            onPressed: _isScanning ? _stopScan : _startScan,
          ),
        ),
      ],
    );
  }
} 