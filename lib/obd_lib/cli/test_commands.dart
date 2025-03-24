import 'dart:async';
import 'package:logging/logging.dart';
import '../interfaces/obd_connection.dart';
import '../protocol/elm327_protocol.dart';
import '../protocol/obd_constants.dart';
import '../models/obd_command.dart';

/// Class containing commands for testing OBD functionality
class TestCommands {
  static final Logger _logger = Logger('TestCommands');
  
  /// Test speed and throttle position readings with smoothing and improved validation
  static Future<void> testSpeedAndThrottleReadings({
    required ObdConnection connection,
    int iterations = 10,
    int delayMs = 500,
  }) async {
    _logger.info('Testing speed and throttle readings with improved processing');
    
    // Initialize protocol
    final protocol = Elm327Protocol(connection, isDebugMode: true);
    
    // Initialize the protocol
    if (!await protocol.initialize()) {
      _logger.severe('Failed to initialize protocol');
      return;
    }
    
    _logger.info('Protocol initialized successfully');
    
    // Set up a stream subscription for data
    StreamSubscription? subscription;
    subscription = protocol.obdDataStream.listen((data) {
      if (data.pid == ObdConstants.pidVehicleSpeed) {
        _logger.info('Speed: ${data.value} ${data.unit}');
      } else if (data.pid == ObdConstants.pidThrottlePosition) {
        _logger.info('Throttle: ${data.value} ${data.unit}');
      } else if (data.pid == ObdConstants.pidEngineRpm) {
        _logger.info('RPM: ${data.value} ${data.unit}');
      }
    });
    
    // Create commands to test
    final speedCommand = ObdCommand.mode01(
      ObdConstants.pidVehicleSpeed,
      name: 'Vehicle Speed',
      description: 'Current vehicle speed',
    );
    
    final throttleCommand = ObdCommand.mode01(
      ObdConstants.pidThrottlePosition,
      name: 'Throttle Position',
      description: 'Current throttle position',
    );
    
    final rpmCommand = ObdCommand.mode01(
      ObdConstants.pidEngineRpm,
      name: 'Engine RPM',
      description: 'Current engine RPM',
    );
    
    // Run the test for specified iterations
    for (int i = 0; i < iterations; i++) {
      _logger.info('Iteration ${i + 1}/$iterations');
      
      try {
        // Request RPM
        await protocol.sendObdCommand(rpmCommand);
        
        // Request speed
        await protocol.sendObdCommand(speedCommand);
        
        // Request throttle position
        await protocol.sendObdCommand(throttleCommand);
        
        // Wait for the next iteration
        await Future.delayed(Duration(milliseconds: delayMs));
      } catch (e) {
        _logger.severe('Error during test: $e');
      }
    }
    
    // Cancel the subscription
    await subscription.cancel();
    
    _logger.info('Test completed');
  }
} 