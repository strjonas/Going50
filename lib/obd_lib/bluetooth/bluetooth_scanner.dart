import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
import 'package:logging/logging.dart';
import '../models/bluetooth_device.dart';

/// Scanner for discovering Bluetooth devices
class BluetoothScanner {
  static final Logger _logger = Logger('BluetoothScanner');
  
  /// The Flutter Reactive BLE instance
  final FlutterReactiveBle _ble;
  
  /// Stream controller for discovered devices
  final _deviceStreamController = StreamController<List<BluetoothDevice>>.broadcast();
  
  /// List of discovered devices
  final List<BluetoothDevice> _discoveredDevices = [];
  
  /// Scan subscription
  StreamSubscription? _scanSubscription;
  
  /// Whether a scan is in progress
  bool _isScanning = false;
  
  /// Creates a new Bluetooth scanner
  BluetoothScanner({FlutterReactiveBle? ble}) : _ble = ble ?? FlutterReactiveBle();
  
  /// Stream of discovered devices
  Stream<List<BluetoothDevice>> get devices => _deviceStreamController.stream;
  
  /// Whether a scan is in progress
  bool get isScanning => _isScanning;
  
  /// Start scanning for Bluetooth devices
  Future<void> startScan({Duration? timeout}) async {
    if (_isScanning) {
      _logger.warning('Scan already in progress');
      return;
    }
    
    _logger.info('Starting Bluetooth scan');
    _isScanning = true;
    _discoveredDevices.clear();
    _deviceStreamController.add(_discoveredDevices);
    
    try {
      _scanSubscription = _ble.scanForDevices(
        withServices: [], // Empty list means scan for all devices
        scanMode: ScanMode.lowLatency,
      ).listen((device) {
        // Only add devices that have a name
        if (device.name.isNotEmpty) {
          _handleDiscoveredDevice(device);
        }
      }, onError: (error) {
        _logger.severe('Scan error: $error');
      });
      
      // Set up a timeout if specified
      if (timeout != null) {
        Future.delayed(timeout, () => stopScan());
      }
    } catch (e) {
      _logger.severe('Error starting scan: $e');
      _isScanning = false;
    }
  }
  
  /// Stop scanning for Bluetooth devices
  Future<void> stopScan() async {
    if (!_isScanning) {
      return;
    }
    
    _logger.info('Stopping Bluetooth scan');
    
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    _isScanning = false;
  }
  
  /// Handle a discovered device
  void _handleDiscoveredDevice(DiscoveredDevice device) {
    final bluetoothDevice = BluetoothDevice(
      id: device.id,
      name: device.name,
      rssi: device.rssi,
      isConnectable: device.connectable == Connectable.available,
    );
    
    // Check if we already discovered this device
    final index = _discoveredDevices.indexWhere((d) => d.id == bluetoothDevice.id);
    
    if (index >= 0) {
      // Update the existing device
      _discoveredDevices[index] = bluetoothDevice;
    } else {
      // Add the new device
      _discoveredDevices.add(bluetoothDevice);
      _logger.info('Discovered device: ${bluetoothDevice.name} (${bluetoothDevice.id})');
    }
    
    // Notify listeners
    _deviceStreamController.add(_discoveredDevices);
  }
  
  /// Dispose the scanner and release resources
  Future<void> dispose() async {
    await stopScan();
    await _deviceStreamController.close();
  }
} 