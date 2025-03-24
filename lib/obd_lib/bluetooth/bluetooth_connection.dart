import 'dart:async';
import 'dart:convert';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
import 'package:logging/logging.dart';
import '../interfaces/obd_connection.dart';
import '../protocol/obd_constants.dart';
import 'response_processor.dart';

/// Bluetooth implementation of OBD connection for ELM327 adapters
class BluetoothConnection implements ObdConnection {
  static final Logger _logger = Logger('BluetoothConnection');
  
  /// The device ID to connect to
  final String _deviceId;
  
  /// The Flutter Reactive BLE instance
  final FlutterReactiveBle _ble;
  
  /// Debug mode flag
  final bool _isDebugMode;
  
  /// Connection status
  bool _isConnected = false;
  
  /// Stream controller for incoming data
  final _dataStreamController = StreamController<String>.broadcast();
  
  /// Subscription to connection state changes
  StreamSubscription? _connectionSubscription;
  
  /// Subscription to characteristic notifications
  StreamSubscription? _characteristicSubscription;
  
  /// Write characteristic for sending commands
  QualifiedCharacteristic? _writeCharacteristic;
  
  /// Notify characteristic for receiving responses
  QualifiedCharacteristic? _notifyCharacteristic;
  
  /// Response buffer for collecting partial responses
  final StringBuffer _responseBuffer = StringBuffer();
  
  /// Response timer for processing complete responses
  Timer? _responseTimer;
  
  /// Flag to track when we're waiting for a response
  bool _awaitingResponse = false;
  
  /// The last command sent - for debugging purposes
  String _lastCommand = '';
  
  /// The response processor to use for this connection
  final ResponseProcessor _responseProcessor;
  
  /// Creates a new Bluetooth connection to an OBD-II adapter
  BluetoothConnection(
    this._deviceId, {
    FlutterReactiveBle? ble,
    bool isDebugMode = false,
    ResponseProcessor? responseProcessor,
  })  : _ble = ble ?? FlutterReactiveBle(),
        _isDebugMode = isDebugMode,
        _responseProcessor = responseProcessor ?? StandardResponseProcessor();
  
  /// Get the device ID
  String get deviceId => _deviceId;
  
  @override
  Stream<String> get dataStream => _dataStreamController.stream;
  
  @override
  bool get isConnected => _isConnected;
  
  @override
  Future<bool> connect() async {
    _logger.info('Connecting to Bluetooth device: $_deviceId');
    
    try {
      // Connect to the device with proper timeout based on platform
      // Android typically needs a longer timeout for BLE connection
      final connectionTimeout = const Duration(milliseconds: ObdConstants.connectionTimeoutMs);
      
      _connectionSubscription = _ble.connectToDevice(
        id: _deviceId,
        connectionTimeout: connectionTimeout,
      ).listen((connectionState) {
        _handleConnectionStateChange(connectionState);
      }, onError: (error) {
        _logger.severe('Connection error: $error');
        _isConnected = false;
        _dataStreamController.add('ERROR: $error');
      });
      
      // Wait for connection to establish with a reasonable timeout
      // The completion timeout is longer than the connection timeout to account for service discovery
      final completer = Completer<bool>();
      
      // Set up a timer to handle connection timeout
      Timer? timeoutTimer;
      timeoutTimer = Timer(Duration(milliseconds: ObdConstants.connectionTimeoutMs * 2), () {
        if (!completer.isCompleted) {
          _logger.warning('Connection timed out');
          completer.complete(false);
        }
      });
      
      // Listen for connection state changes
      final subscription = _dataStreamController.stream.listen((data) {
        if (data == 'CONNECTED' && !completer.isCompleted) {
          timeoutTimer?.cancel();
          completer.complete(true);
        } else if (data.startsWith('ERROR:') && !completer.isCompleted) {
          timeoutTimer?.cancel();
          completer.complete(false);
        }
      });
      
      // Wait for connection result
      final result = await completer.future;
      
      // Clean up
      subscription.cancel();
      timeoutTimer?.cancel();
      
      return result;
    } catch (e) {
      _logger.severe('Failed to connect: $e');
      return false;
    }
  }
  
  /// Handle connection state changes
  void _handleConnectionStateChange(ConnectionStateUpdate state) {
    _logger.info('Connection state: ${state.connectionState}');
    
    switch (state.connectionState) {
      case DeviceConnectionState.connected:
        _isConnected = true;
        _dataStreamController.add('CONNECTED');
        _discoverServices();
        break;
      case DeviceConnectionState.disconnected:
        _isConnected = false;
        _clearResponseBuffer();
        _dataStreamController.add('DISCONNECTED');
        break;
      default:
        // Ignore other states
        break;
    }
  }
  
  /// Discover services and characteristics
  Future<void> _discoverServices() async {
    _logger.info('Discovering services...');
    
    try {
      // Use the original method with @SuppressWarnings to avoid linter warnings
      // ignore: deprecated_member_use
      final services = await _ble.discoverServices(_deviceId);
      _logger.info('Found ${services.length} services');
      
      // Get the target UUIDs with proper formatting for cross-platform compatibility
      // Match either the full UUID or the short 4-character UUID
      final targetServiceUuid = ObdConstants.serviceUuid.toLowerCase();
      final targetNotifyUuid = ObdConstants.notifyCharacteristicUuid.toLowerCase();
      final targetWriteUuid = ObdConstants.writeCharacteristicUuid.toLowerCase();
      
      // Extract short UUIDs (the 4-character version) for alternative matching
      final shortServiceUuid = targetServiceUuid.contains('0000') ? 
          targetServiceUuid.split('-')[0].substring(4, 8) : 
          targetServiceUuid;
      
      final shortNotifyUuid = targetNotifyUuid.contains('0000') ? 
          targetNotifyUuid.split('-')[0].substring(4, 8) : 
          targetNotifyUuid;
      
      final shortWriteUuid = targetWriteUuid.contains('0000') ? 
          targetWriteUuid.split('-')[0].substring(4, 8) : 
          targetWriteUuid;
      
      // Log the UUIDs we're looking for
      _logger.info('Looking for service UUID: $targetServiceUuid or $shortServiceUuid');
      _logger.info('Looking for notify UUID: $targetNotifyUuid or $shortNotifyUuid');
      _logger.info('Looking for write UUID: $targetWriteUuid or $shortWriteUuid');
      
      // For cross-platform compatibility, we need to handle UUID matching
      // with flexible rules that work on both Android and iOS
      bool isTargetService(String serviceIdStr) {
        // Convert to lowercase for case-insensitive comparison
        serviceIdStr = serviceIdStr.toLowerCase();
        
        // Check multiple formats: full UUID or the short 4-character version
        return serviceIdStr.contains(targetServiceUuid) || 
               serviceIdStr.contains(shortServiceUuid);
      }
      
      bool isTargetCharacteristic(String charIdStr, String fullUuid, String shortUuid) {
        // Convert to lowercase for case-insensitive comparison
        charIdStr = charIdStr.toLowerCase();
        
        // Check multiple formats
        return charIdStr.contains(fullUuid) || 
               charIdStr.contains(shortUuid);
      }
      
      // Log all services and characteristics for debugging
      for (final service in services) {
        // Get service UUID string
        final serviceIdStr = service.serviceId.toString().toLowerCase();
        _logger.info('Service: $serviceIdStr');
        
        // Check if this is the service we're looking for
        final isOurTargetService = isTargetService(serviceIdStr);
        
        for (final characteristic in service.characteristics) {
          // Get characteristic UUID string
          final characteristicIdStr = characteristic.characteristicId.toString().toLowerCase();
          
          // Log properties for debugging
          final propertyFlags = <String>[];
          if (characteristic.isReadable) propertyFlags.add('READ');
          if (characteristic.isWritableWithoutResponse) propertyFlags.add('WRITE_NO_RESPONSE');
          if (characteristic.isWritableWithResponse) propertyFlags.add('WRITE');
          if (characteristic.isNotifiable) propertyFlags.add('NOTIFY');
          if (characteristic.isIndicatable) propertyFlags.add('INDICATE');
          
          _logger.info('  Characteristic: $characteristicIdStr [${propertyFlags.join(", ")}]');
          
          // If this is our target service, look for the characteristics
          if (isOurTargetService) {
            // Set up the write characteristic
            if ((characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse) &&
                isTargetCharacteristic(characteristicIdStr, targetWriteUuid, shortWriteUuid)) {
              _writeCharacteristic = QualifiedCharacteristic(
                serviceId: service.serviceId,
                characteristicId: characteristic.characteristicId,
                deviceId: _deviceId,
              );
              _logger.info('  Selected for WRITE: ${characteristic.characteristicId}');
            }
            
            // Set up the notify characteristic
            if ((characteristic.isNotifiable || characteristic.isIndicatable) &&
                isTargetCharacteristic(characteristicIdStr, targetNotifyUuid, shortNotifyUuid)) {
              _notifyCharacteristic = QualifiedCharacteristic(
                serviceId: service.serviceId,
                characteristicId: characteristic.characteristicId,
                deviceId: _deviceId,
              );
              _logger.info('  Selected for NOTIFY: ${characteristic.characteristicId}');
            }
          }
        }
      }
      
      // If we found the characteristics, set up the communication
      if (_notifyCharacteristic != null) {
        await _subscribeToNotifications();
      } else {
        _logger.warning('No notify characteristic found');
        _dataStreamController.add('ERROR: No notify characteristic found');
        // Update connection status since we can't communicate without notify characteristic
        _isConnected = false;
      }
      
      if (_writeCharacteristic == null) {
        _logger.warning('No write characteristic found');
        _dataStreamController.add('ERROR: No write characteristic found');
        // Update connection status since we can't communicate without write characteristic
        _isConnected = false;
      }
      
      // Connection is only complete if we have both characteristics
      if (_notifyCharacteristic != null && _writeCharacteristic != null) {
        _logger.info('Bluetooth fully connected with all required characteristics');
        // Wait an additional 2000ms as required by the rules for proper connection
        await Future.delayed(const Duration(milliseconds: 2000));
      } else {
        _logger.warning('Bluetooth connected but missing required characteristics');
        _isConnected = false;
      }
    } catch (e) {
      _logger.severe('Service discovery error: $e');
      _dataStreamController.add('ERROR: Service discovery error: $e');
      _isConnected = false;
    }
  }
  
  /// Subscribe to notifications from the OBD-II adapter
  Future<void> _subscribeToNotifications() async {
    if (_notifyCharacteristic == null) return;
    
    _logger.info('Subscribing to notifications');
    
    try {
      _characteristicSubscription = _ble.subscribeToCharacteristic(_notifyCharacteristic!).listen(
        (data) => _handleIncomingData(data),
        onError: (error) {
          _logger.severe('Notification error: $error');
          _dataStreamController.add('ERROR: Notification error: $error');
        },
      );
      
      _logger.info('Subscribed to notifications successfully');
    } catch (e) {
      _logger.severe('Failed to subscribe to notifications: $e');
      _dataStreamController.add('ERROR: Failed to subscribe to notifications: $e');
    }
  }
  
  /// Clear the response buffer and cancel the timer
  void _clearResponseBuffer() {
    _responseBuffer.clear();
    _responseTimer?.cancel();
    _responseTimer = null;
    _awaitingResponse = false;
  }
  
  /// Check if the response appears to be complete
  bool _isResponseComplete(String response) {
    // Check for common patterns indicating a complete response
    return response.endsWith('\r\n>') || 
           response.endsWith('\r>') || 
           response.endsWith('\n>') || 
           response.endsWith('>') ||
           response.contains('NO DATA') ||
           response.contains('ERROR');
  }
  
  /// Handle incoming data from the OBD-II adapter
  void _handleIncomingData(List<int> data) {
    if (data.isEmpty) return;
    
    try {
      // Use the response processor to handle adapter-specific data processing
      final receivedText = _responseProcessor.processIncomingData(data, _isDebugMode);
      
      // Add to the response buffer
      _responseBuffer.write(receivedText);
      final bufferContent = _responseBuffer.toString();
      
      // Reset the response timer
      _responseTimer?.cancel();
      _responseTimer = Timer(const Duration(milliseconds: ObdConstants.responseTimeoutMs), () {
        if (_responseBuffer.isEmpty) return;
        
        final response = _responseBuffer.toString().trim();
        _responseBuffer.clear();
        _awaitingResponse = false;
        
        if (response.isNotEmpty) {
          if (_isDebugMode) {
            _logger.info('Complete response (timeout) for command $_lastCommand: $response');
          } else {
            _logger.info('Complete response (timeout): $response');
          }
          _dataStreamController.add(response);
        }
      });
      
      // If the response appears complete, process it immediately
      if (_isResponseComplete(bufferContent)) {
        _responseTimer?.cancel();
        final response = bufferContent.trim();
        _responseBuffer.clear();
        _awaitingResponse = false;
        
        if (response.isNotEmpty) {
          if (_isDebugMode) {
            _logger.info('Complete response for command $_lastCommand: $response');
          } else {
            _logger.info('Complete response: $response');
          }
          _dataStreamController.add(response);
        }
      }
    } catch (e) {
      _logger.warning('Error handling incoming data: $e');
      
      // In case of error, clear the buffer and reset
      _clearResponseBuffer();
    }
  }
  
  @override
  Future<void> sendCommand(String command) async {
    if (!_isConnected) {
      _logger.warning('Cannot send command: not connected');
      _dataStreamController.add('ERROR: Cannot send command - not connected');
      return;
    }
    
    if (_writeCharacteristic == null) {
      _logger.warning('Cannot send command: no write characteristic');
      _dataStreamController.add('ERROR: Cannot send command - no write characteristic');
      return;
    }
    
    // Wait for any previous command to complete
    int attempts = 0;
    while (_awaitingResponse && attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      attempts++;
    }
    
    // Process the command through the response processor
    final processedCommand = _responseProcessor.processOutgoingCommand(command);
    
    // Add the command terminator
    final fullCommand = processedCommand + ObdConstants.commandTerminator;
    _lastCommand = command;
    _awaitingResponse = true;
    
    if (_isDebugMode) {
      _logger.fine('Sending command: $command');
    }
    
    try {
      // Use write with response for more reliable communication
      await _ble.writeCharacteristicWithResponse(
        _writeCharacteristic!,
        value: utf8.encode(fullCommand),
      );
      
      if (_isDebugMode) {
        _logger.fine('Command sent successfully');
      }
    } catch (e) {
      _logger.severe('Error sending command: $e');
      _dataStreamController.add('ERROR: Failed to send command: $e');
      _awaitingResponse = false;
    }
  }
  
  @override
  Future<void> disconnect() async {
    _logger.info('Disconnecting from Bluetooth device');
    
    _isConnected = false;
    _clearResponseBuffer();
    await _characteristicSubscription?.cancel();
    await _connectionSubscription?.cancel();
    
    _characteristicSubscription = null;
    _connectionSubscription = null;
    
    _logger.info('Disconnected');
  }
  
  @override
  Future<void> dispose() async {
    _logger.info('Disposing Bluetooth connection');
    
    await disconnect();
    await _dataStreamController.close();
    
    _logger.info('Disposed');
  }
} 