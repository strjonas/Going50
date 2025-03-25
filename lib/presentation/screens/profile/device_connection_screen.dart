import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/widgets/common/indicators/status_indicator.dart';
import 'package:going50/presentation/screens/profile/components/device_scanner.dart';
import 'package:going50/presentation/screens/profile/components/connection_manager.dart';
import 'package:going50/presentation/screens/profile/components/adapter_config.dart';

/// A screen for managing OBD device connections and adapter configuration.
class DeviceConnectionScreen extends StatefulWidget {
  /// Constructor
  const DeviceConnectionScreen({super.key});

  @override
  State<DeviceConnectionScreen> createState() => _DeviceConnectionScreenState();
}

class _DeviceConnectionScreenState extends State<DeviceConnectionScreen> {
  String? _errorMessage;
  int _currentStep = 0;
  
  @override
  void initState() {
    super.initState();
    
    // After the first frame is rendered, check if we need to show the scanner
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialStep();
    });
  }
  
  /// Sets the initial step based on connection status
  void _setInitialStep() {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    // If not connected, go directly to the scanner step
    if (!drivingProvider.isObdConnected && mounted) {
      setState(() {
        _currentStep = 1; // Device scanner step
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final drivingProvider = Provider.of<DrivingProvider>(context);
    final isConnected = drivingProvider.isObdConnected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD Connection'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildContent(context, isConnected),
      ),
    );
  }

  /// Builds the main content of the screen
  Widget _buildContent(BuildContext context, bool isConnected) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(context, isConnected),
          
          const SizedBox(height: 24),
          
          // Error message
          if (_errorMessage != null) ...[
            StatusIndicator(
              text: _errorMessage!,
              type: StatusType.error,
              icon: Icons.error_outline,
            ),
            const SizedBox(height: 24),
          ],
          
          // Connection steps
          _buildConnectionSteps(context, isConnected),
        ],
      ),
    );
  }

  /// Builds the connection status card
  Widget _buildStatusCard(BuildContext context, bool isConnected) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
              size: 36,
              color: isConnected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected ? 'Connected' : 'Not Connected',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isConnected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isConnected
                        ? 'Your OBD adapter is connected and ready to use'
                        : 'Scan for devices below to connect your OBD adapter',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the connection steps
  Widget _buildConnectionSteps(BuildContext context, bool isConnected) {
    return Stepper(
      physics: const ClampingScrollPhysics(),
      currentStep: _currentStep,
      controlsBuilder: (context, details) {
        // No controls needed
        return const SizedBox.shrink();
      },
      onStepTapped: (step) {
        setState(() {
          _currentStep = step;
        });
      },
      steps: [
        // Step 1: Connection Status
        Step(
          title: const Text('Connection Status'),
          subtitle: Text(isConnected ? 'Connected' : 'Not Connected'),
          content: ConnectionManager(
            onDisconnected: () {
              setState(() {
                _currentStep = 1; // Go to device scanner step
              });
            },
          ),
          isActive: _currentStep == 0,
          state: _getStepState(0, isConnected),
        ),
        
        // Step 2: Device Scanner
        Step(
          title: const Text('Available Devices'),
          subtitle: const Text('Select a device to connect'),
          content: DeviceScanner(
            onDeviceSelected: (device) {
              _connectToDevice(device);
            },
          ),
          isActive: _currentStep == 1,
          state: _getStepState(1, isConnected),
        ),
        
        // Step 3: Adapter Configuration
        Step(
          title: const Text('Adapter Configuration'),
          subtitle: const Text('Advanced settings'),
          content: const AdapterConfig(),
          isActive: _currentStep == 2,
          state: _getStepState(2, isConnected),
        ),
      ],
    );
  }
  
  /// Gets the appropriate step state based on the step index and connection status
  StepState _getStepState(int stepIndex, bool isConnected) {
    if (stepIndex == 0 && isConnected) {
      return StepState.complete;
    } else if (stepIndex == 1 && !isConnected) {
      return StepState.indexed;
    } else {
      return StepState.indexed;
    }
  }

  /// Connects to the selected OBD device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    
    setState(() {
      _errorMessage = null;
    });

    try {
      final success = await drivingProvider.connectToObdDevice(device.id);
      
      if (!mounted) return;
      
      if (success) {
        // Go to status step
        setState(() {
          _currentStep = 0;
        });
        
        // Show success snackbar
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Connected to ${device.name}'),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to connect to device';
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Connection error: $e';
      });
    }
  }
} 