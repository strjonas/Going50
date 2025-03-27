import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/widgets/common/indicators/status_indicator.dart';
import 'package:going50/presentation/screens/profile/components/device_scanner.dart';
import 'package:going50/presentation/screens/profile/components/connection_manager.dart';
import 'package:going50/presentation/screens/profile/components/adapter_config.dart';
import 'package:going50/services/driving/obd_connection_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isConnecting = false;
  double _connectionProgress = 0.0;
  String _connectionStatus = '';
  BluetoothDevice? _selectedDevice;
  
  // Connection cancel token
  bool _cancelRequested = false;
  
  // Add this property to track mounted state safely 
  bool _isMounted = true;
  
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    
    // After the first frame is rendered, check if we need to show the scanner
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialStep();
    });
  }
  
  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  /// Cleanup method that should be called on connection cancel or error
  Future<void> _cleanup() async {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    // If we're in the process of connecting, make sure to disconnect
    if (_isConnecting && drivingProvider.isObdConnected) {
      await drivingProvider.disconnectObdDevice();
    }
    
    // Reset state variables
    if (_isMounted) {
      setState(() {
        _isConnecting = false;
        _cancelRequested = false;
      });
    }
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
      body: Stack(
        children: [
          SafeArea(
            child: _buildContent(context, isConnected),
          ),
          // Connection loading overlay
          if (_isConnecting)
            _buildConnectionOverlay(context),
        ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isConnected
                        ? 'Your OBD adapter is connected and ready to use'
                        : 'Scan for devices below to connect your OBD adapter',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
    // Add MediaQuery to adapt to screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360; // Adjust threshold as needed
    
    return Stepper(
      physics: const ClampingScrollPhysics(),
      currentStep: _currentStep,
      // Adapt margin for smaller screens
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 0 : 16),
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
          subtitle: Text(
            isConnected ? 'Connected' : 'Not Connected',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
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
          subtitle: const Text(
            'Select a device to connect',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
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
          subtitle: const Text(
            'Advanced settings',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
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

  /// Builds the connection loading overlay
  Widget _buildConnectionOverlay(BuildContext context) {
    // Find the matching stage details based on current status
    final List<Map<String, String>> connectionStages = [
      {
        'status': 'Initializing Bluetooth connection...',
        'details': 'Establishing Bluetooth connection to the device. Please make sure the OBD adapter is powered on.',
      },
      {
        'status': 'Connecting to Bluetooth device...',
        'details': 'Negotiating connection parameters and establishing a secure link to your OBD adapter.',
      },
      {
        'status': 'Discovering OBD services...',
        'details': 'Scanning for available communication services on the adapter. This may take a moment.',
      },
      {
        'status': 'Establishing OBD protocol...',
        'details': 'Configuring the communication protocol with your vehicle\'s computer. This determines how data is exchanged.',
      },
      {
        'status': 'Initializing adapter...',
        'details': 'Setting up the adapter with optimal parameters for your vehicle to ensure reliability.',
      },
      {
        'status': 'Testing connection...',
        'details': 'Verifying that the connection is stable and can retrieve data from your vehicle properly.',
      },
      {
        'status': 'Finalizing setup...',
        'details': 'Completing the connection process and preparing for data collection.',
      },
      {
        'status': 'Connection successful!',
        'details': 'Your OBD adapter is now connected and ready to use.',
      },
      {
        'status': 'Cancelling connection...',
        'details': 'Safely disconnecting from the OBD adapter.',
      },
    ];
    
    String details = 'Please wait while we connect to your OBD adapter.';
    for (final stage in connectionStages) {
      if (stage['status'] == _connectionStatus) {
        details = stage['details'] ?? details;
        break;
      }
    }
    
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        color: Colors.black54,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Connecting to ${_selectedDevice?.name ?? 'device'}',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  LinearProgressIndicator(value: _connectionProgress),
                  const SizedBox(height: 16),
                  Text(
                    _connectionStatus,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _cancelRequested = true;
                        _connectionStatus = 'Cancelling connection...';
                      });
                      await _cleanup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Connects to the selected OBD device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final obdService = serviceLocator<ObdConnectionService>();
    
    // Store selected device and reset variables
    _selectedDevice = device;
    _cancelRequested = false;
    _connectionProgress = 0.0;
    _connectionStatus = 'Initializing connection...';
    
    setState(() {
      _errorMessage = null;
      _isConnecting = true;
    });
    
    // Stages of connection with detailed descriptions
    final List<Map<String, String>> connectionStages = [
      {
        'status': 'Initializing Bluetooth connection...',
        'details': 'Establishing Bluetooth connection to the device. Please make sure the OBD adapter is powered on.',
      },
      {
        'status': 'Connecting to Bluetooth device...',
        'details': 'Negotiating connection parameters and establishing a secure link to your OBD adapter.',
      },
      {
        'status': 'Discovering OBD services...',
        'details': 'Scanning for available communication services on the adapter. This may take a moment.',
      },
      {
        'status': 'Establishing OBD protocol...',
        'details': 'Configuring the communication protocol with your vehicle\'s computer. This determines how data is exchanged.',
      },
      {
        'status': 'Initializing adapter...',
        'details': 'Setting up the adapter with optimal parameters for your vehicle to ensure reliability.',
      },
      {
        'status': 'Testing connection...',
        'details': 'Verifying that the connection is stable and can retrieve data from your vehicle properly.',
      },
      {
        'status': 'Finalizing setup...',
        'details': 'Completing the connection process and preparing for data collection.',
      },
    ];
    
    int currentStage = 0;
    
    // Update progress with more detailed stage information
    final progressTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_cancelRequested) {
        timer.cancel();
        return;
      }
      
      // Only move to next stage if not at the end
      if (currentStage < connectionStages.length - 1) {
        // Update to next stage approximately every 2-3 seconds
        if (timer.tick % 3 == 0) {
          currentStage = (currentStage + 1).clamp(0, connectionStages.length - 1);
        }
        
        final stageProgress = timer.tick % 3 / 3; // Progress within current stage
        final overallProgress = (currentStage + stageProgress) / connectionStages.length;
        
        if (_isMounted) {
          setState(() {
            _connectionProgress = overallProgress;
            _connectionStatus = connectionStages[currentStage]['status'] ?? 'Connecting...';
          });
        }
      }
    });

    try {
      // Get the preferred profile for this device from shared preferences
      final profileId = await _getPreferredProfileForDevice(device.id);
      
      // If the user has a profile preference for this device, use it
      if (profileId != null) {
        // Set the profile before connecting
        obdService.setAdapterProfile(profileId);
      }
      
      // Attempt to connect with progress updates
      final success = await drivingProvider.connectToObdDevice(device.id);
      
      // Cancel the timer
      progressTimer.cancel();
      
      if (!_isMounted) return;
      
      // If cancel was requested during connection
      if (_cancelRequested) {
        // Disconnect if connection was successful but cancel was requested
        if (success) {
          await drivingProvider.disconnectObdDevice();
        }
        
        if (_isMounted) {
          setState(() {
            _isConnecting = false;
          });
        }
        
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Connection cancelled')),
        );
        return;
      }
      
      if (success) {
        // Complete the progress bar animation
        setState(() {
          _connectionProgress = 1.0;
          _connectionStatus = 'Connection successful!';
        });
        
        // Brief delay to show the completed progress
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Hide the connection overlay
        setState(() {
          _isConnecting = false;
        });
        
        // If no preferred profile was used, ask user if they want to set one
        if (profileId == null) {
          _showProfileSelectionDialog(device);
        } else {
          // Go to status step
          setState(() {
            _currentStep = 0;
          });
        }
        
        // Show success snackbar with overflow protection
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Connected to ${device.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
      } else {
        setState(() {
          _isConnecting = false;
          _errorMessage = 'Failed to connect to device';
        });
      }
    } catch (e) {
      // Cancel the timer
      progressTimer.cancel();
      
      // Clean up
      await _cleanup();
      
      if (!_isMounted) return;
      
      setState(() {
        _errorMessage = 'Connection error: $e';
      });
    }
  }
  
  /// Shows a dialog to select a profile after successful connection
  void _showProfileSelectionDialog(BluetoothDevice device) {
    // Get list of available profiles
    final obdService = serviceLocator<ObdConnectionService>();
    final profiles = obdService.getAvailableProfiles();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Adapter Profile'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a profile for this device. The app has automatically '
                'selected the best profile, but you can change it if needed.',
              ),
              const SizedBox(height: 16),
              ...profiles.map((profile) => RadioListTile<String>(
                title: Text(profile['name'] ?? 'Unknown'),
                subtitle: Text(
                  profile['description'] ?? 'No description',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                value: profile['id'] ?? '',
                groupValue: null, // Initially no selection
                onChanged: (value) {
                  if (value != null) {
                    Navigator.of(context).pop(value);
                  }
                },
              )),
              RadioListTile<String>(
                title: const Text('Automatic (Recommended)'),
                subtitle: const Text('Let the app select the best profile automatically'),
                value: 'auto',
                groupValue: null, // Initially no selection
                onChanged: (value) {
                  Navigator.of(context).pop('auto');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Skip'),
          ),
        ],
      ),
    ).then((profileId) async {
      // Remember user's selection for this device
      if (profileId != null) {
        final obdService = serviceLocator<ObdConnectionService>();
        if (profileId == 'auto') {
          await _savePreferredProfileForDevice(device.id, null);
          obdService.enableAutomaticProfileDetection();
        } else {
          await _savePreferredProfileForDevice(device.id, profileId);
          obdService.setAdapterProfile(profileId);
        }
      }
      
      // Go to status step
      setState(() {
        _currentStep = 0;
      });
    });
  }
  
  /// Gets the preferred profile for a device
  Future<String?> _getPreferredProfileForDevice(String deviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('device_profile_$deviceId');
    } catch (e) {
      // Handle error
      debugPrint('Error retrieving device profile preference: $e');
      return null;
    }
  }
  
  /// Saves the preferred profile for a device
  Future<void> _savePreferredProfileForDevice(String deviceId, String? profileId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (profileId == null) {
        // Remove the preference if we're using automatic detection
        await prefs.remove('device_profile_$deviceId');
      } else {
        // Save the profile preference
        await prefs.setString('device_profile_$deviceId', profileId);
      }
    } catch (e) {
      // Handle error
      debugPrint('Error saving device profile preference: $e');
    }
  }
} 