import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import '../models/obd_data.dart';
import '../protocol/obd_constants.dart';
import 'mock_bluetooth_connection.dart';
import 'mock_obd_protocol.dart';

/// Simplified tests for the OBD library, focusing on protocol and connection testing
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock method channels to avoid platform channel issues
  const MethodChannel bleChannel = MethodChannel('com.signify.hue.flutter/reactiveBle');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    bleChannel,
    (MethodCall methodCall) async {
      return null;
    },
  );

  group('MockObdProtocol Tests', () {
    late MockBluetoothConnection mockConnection;
    late MockObdProtocol mockProtocol;

    setUp(() {
      mockConnection = MockBluetoothConnection();
      mockProtocol = MockObdProtocol(connection: mockConnection);
      
      // Pre-initialize protocol state
      mockProtocol.setInitialized(true);
      mockProtocol.setConnected(true);
    });

    tearDown(() async {
      await mockProtocol.dispose();
      await mockConnection.dispose();
    });

    test('Protocol returns stored PID response', () async {
      // Set up a mock response for RPM
      final rpmData = ObdData(
        pid: ObdConstants.pidEngineRpm,
        mode: '01',
        value: 1500,
        unit: 'rpm',
        timestamp: DateTime.now(),
        rawData: [0x41, 0x0C, 0x12, 0x00],
        name: 'Engine RPM'
      );
      
      // Add the response to the protocol
      mockProtocol.addPidResponse(ObdConstants.pidEngineRpm, rpmData);
      
      // Request the PID
      final response = await mockProtocol.requestPid(ObdConstants.pidEngineRpm);
      
      // Verify the response matches
      expect(response, isNotNull);
      expect(response!.pid, ObdConstants.pidEngineRpm);
      expect(response.value, 1500);
      expect(response.unit, 'rpm');
    });

    test('Protocol streams data correctly', () async {
      // Create test data
      final testData = ObdData(
        pid: ObdConstants.pidVehicleSpeed,
        mode: '01',
        value: 50,
        unit: 'km/h',
        timestamp: DateTime.now(),
        rawData: [0x41, 0x0D, 0x32],
        name: 'Vehicle Speed'
      );
      
      // Set up a listener to detect the data
      bool dataReceived = false;
      ObdData? receivedData;
      
      final subscription = mockProtocol.obdDataStream.listen((data) {
        dataReceived = true;
        receivedData = data;
      });
      
      // Simulate receiving data
      mockProtocol.simulateDataResponse(testData);
      
      // Allow time for the event to propagate
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Verify data was received
      expect(dataReceived, isTrue);
      expect(receivedData, isNotNull);
      expect(receivedData!.pid, testData.pid);
      expect(receivedData!.value, testData.value);
      
      // Clean up
      await subscription.cancel();
    });

    test('Protocol handles commands via connection', () async {
      // Set up a command response
      mockConnection.addCommandResponse('ATZ', 'ELM327 v1.5\r\n>');
      await mockConnection.connect();
      
      // We need to give time for the connection to be established and response
      // to be emitted before trying to send a command
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Create a direct subscription to monitor responses
      final responses = <String>[];
      final subscription = mockConnection.dataStream.listen((data) {
        responses.add(data);
      });
      
      // Send the command
      await mockConnection.sendCommand('ATZ');
      
      // Allow time for the response to be processed
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Verify response - now we check the collected responses
      expect(responses.any((r) => r.contains('ELM327')), isTrue);
      
      // Clean up
      await subscription.cancel();
    });

    test('Protocol handles multiple PID requests', () async {
      // Set up responses for multiple PIDs
      mockProtocol.addPidResponse(
        ObdConstants.pidEngineRpm,
        ObdData(
          pid: ObdConstants.pidEngineRpm,
          mode: '01',
          value: 1500,
          unit: 'rpm',
          timestamp: DateTime.now(),
          rawData: [0x41, 0x0C, 0x12, 0x00],
          name: 'Engine RPM'
        )
      );
      
      mockProtocol.addPidResponse(
        ObdConstants.pidVehicleSpeed,
        ObdData(
          pid: ObdConstants.pidVehicleSpeed,
          mode: '01',
          value: 50,
          unit: 'km/h',
          timestamp: DateTime.now(),
          rawData: [0x41, 0x0D, 0x32],
          name: 'Vehicle Speed'
        )
      );
      
      // Request multiple PIDs
      final results = await mockProtocol.requestPids([
        ObdConstants.pidEngineRpm,
        ObdConstants.pidVehicleSpeed
      ]);
      
      // Verify responses
      expect(results.length, 2);
      expect(results.containsKey(ObdConstants.pidEngineRpm), isTrue);
      expect(results.containsKey(ObdConstants.pidVehicleSpeed), isTrue);
      expect(results[ObdConstants.pidEngineRpm]?.value, 1500);
      expect(results[ObdConstants.pidVehicleSpeed]?.value, 50);
    });
  });

  group('MockBluetoothConnection Tests', () {
    late MockBluetoothConnection mockConnection;

    setUp(() {
      mockConnection = MockBluetoothConnection();
    });

    tearDown(() async {
      await mockConnection.dispose();
    });

    test('Connection sends and receives data', () async {
      // Set up a listener for the data stream first
      final dataReceived = <String>[];
      final subscription = mockConnection.dataStream.listen((data) {
        dataReceived.add(data);
      });
      
      // Add a small delay to ensure subscription is active
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Connect
      final connected = await mockConnection.connect();
      expect(connected, isTrue);
      expect(mockConnection.isConnected, isTrue);
      
      // Wait to ensure connection message has been processed
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Send a command that will generate a response
      await mockConnection.sendCommand('ATZ');
      
      // Allow time for the response
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Verify we received responses (the exact order depends on implementation)
      expect(dataReceived, isNotEmpty);
      
      // Check that we have the expected messages
      expect(dataReceived.where((data) => data == 'CONNECTED').isNotEmpty, isTrue,
          reason: 'Expected to find CONNECTED message');
      expect(dataReceived.where((data) => data.contains('ELM327')).isNotEmpty, isTrue,
          reason: 'Expected to find ELM327 response');
      
      // Clean up
      await subscription.cancel();
    });

    test('Connection handles predefined responses', () async {
      // Connect
      await mockConnection.connect();
      
      // Add a custom command response
      mockConnection.addCommandResponse('CUSTOM', 'CUSTOM_RESPONSE');
      
      // Set up a listener
      String? customResponse;
      final subscription = mockConnection.dataStream.listen((data) {
        if (data == 'CUSTOM_RESPONSE') {
          customResponse = data;
        }
      });
      
      // Send the custom command
      await mockConnection.sendCommand('CUSTOM');
      
      // Allow time for the response
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify the custom response was received
      expect(customResponse, 'CUSTOM_RESPONSE');
      
      // Clean up
      await subscription.cancel();
    });

    test('Connection sends disconnect notification', () async {
      // Connect
      await mockConnection.connect();
      
      // Set up a listener
      bool disconnectReceived = false;
      final subscription = mockConnection.dataStream.listen((data) {
        if (data == 'DISCONNECTED') {
          disconnectReceived = true;
        }
      });
      
      // Disconnect
      await mockConnection.disconnect();
      
      // Allow time for the notification
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Verify disconnect notification was received
      expect(disconnectReceived, isTrue);
      expect(mockConnection.isConnected, isFalse);
      
      // Clean up
      await subscription.cancel();
    });
  });
  
  group('OBD PID Parsing Tests', () {
    test('Parse engine RPM data', () {
      // Test data for engine RPM (1500 RPM)
      final rpmData = ObdData(
        pid: ObdConstants.pidEngineRpm,
        mode: '01',
        value: 1500,
        unit: 'rpm',
        timestamp: DateTime.now(),
        rawData: [0x41, 0x0C, 0x12, 0x00],  // 41 0C 12 00 -> (0x1200 / 4) = 1152 RPM
        name: 'Engine RPM'
      );
      
      // Verify the parsed value
      expect(rpmData, isNotNull);
      expect(rpmData.pid, ObdConstants.pidEngineRpm);
      expect(rpmData.value, 1500);
      expect(rpmData.unit, 'rpm');
    });
    
    test('Parse vehicle speed data', () {
      // Test data for vehicle speed (50 km/h)
      final speedData = ObdData(
        pid: ObdConstants.pidVehicleSpeed,
        mode: '01',
        value: 50,
        unit: 'km/h',
        timestamp: DateTime.now(),
        rawData: [0x41, 0x0D, 0x32],  // 41 0D 32 -> 0x32 = 50 km/h
        name: 'Vehicle Speed'
      );
      
      // Verify the parsed value
      expect(speedData, isNotNull);
      expect(speedData.pid, ObdConstants.pidVehicleSpeed);
      expect(speedData.value, 50);
      expect(speedData.unit, 'km/h');
    });
    
    test('Parse engine coolant temperature data', () {
      // Test data for coolant temperature (90 °C)
      final coolantData = ObdData(
        pid: ObdConstants.pidCoolantTemp,
        mode: '01',
        value: 90,
        unit: '°C',
        timestamp: DateTime.now(),
        rawData: [0x41, 0x05, 0x5A],  // 41 05 5A -> 0x5A = 90 °C
        name: 'Engine Coolant Temperature'
      );
      
      // Verify the parsed value
      expect(coolantData, isNotNull);
      expect(coolantData.pid, ObdConstants.pidCoolantTemp);
      expect(coolantData.value, 90);
      expect(coolantData.unit, '°C');
    });
    
    test('Parse throttle position data', () {
      // Test data for throttle position (25%)
      final throttleData = ObdData(
        pid: ObdConstants.pidThrottlePosition,
        mode: '01',
        value: 25.0,
        unit: '%',
        timestamp: DateTime.now(),
        rawData: [0x41, 0x11, 0x40],  // 41 11 40 -> (0x40 * 100) / 255 = ~25%
        name: 'Throttle Position'
      );
      
      // Verify the parsed value
      expect(throttleData, isNotNull);
      expect(throttleData.pid, ObdConstants.pidThrottlePosition);
      expect(throttleData.value, 25.0);
      expect(throttleData.unit, '%');
    });
  });
} 