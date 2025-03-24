import 'package:flutter/material.dart';
import '../obd_factory.dart';
import '../obd_service.dart';
import '../protocol/obd_constants.dart';
import 'mock_test_data.dart';

/// Example of using the mock OBD implementation
///
/// This example demonstrates how to use the mock OBD implementation
/// for testing without requiring actual hardware.
class MockObdExample extends StatefulWidget {
  const MockObdExample({super.key});

  @override
  State<MockObdExample> createState() => _MockObdExampleState();
}

class _MockObdExampleState extends State<MockObdExample> {
  final ObdService _obdService = ObdService(isDebugMode: true);
  String _status = 'Disconnected';
  final Map<String, String> _data = {};
  String _selectedScenario = 'city_driving';

  @override
  void initState() {
    super.initState();
    _setupService();
  }

  @override
  void dispose() {
    _obdService.disconnect();
    super.dispose();
  }

  /// Set up the OBD service with the mock profile
  Future<void> _setupService() async {
    // Set the mock adapter profile
    _obdService.setAdapterProfile('mock_elm327');
    
    // Listen for data updates
    _obdService.addListener(() {
      if (mounted) {
        setState(() {
          _status = _obdService.isConnected ? 'Connected' : 'Disconnected';
          
          // Update data display
          _data.clear();
          _obdService.latestData.forEach((pid, data) {
            _data[data.name] = '${data.value} ${data.unit}';
          });
        });
      }
    });
  }

  /// Connect to the mock OBD adapter
  Future<void> _connect() async {
    setState(() {
      _status = 'Connecting...';
    });
    
    // Connect to the mock device
    final connected = await _obdService.connect('MOCK_DEVICE');
    
    setState(() {
      _status = connected ? 'Connected' : 'Connection failed';
    });
  }

  /// Disconnect from the mock OBD adapter
  Future<void> _disconnect() async {
    _obdService.disconnect();
    
    setState(() {
      _status = 'Disconnected';
      _data.clear();
    });
  }

  /// Change the test scenario
  void _changeScenario(String scenario) {
    setState(() {
      _selectedScenario = scenario;
    });
    
    // Disconnect first if connected
    if (_obdService.isConnected) {
      _obdService.disconnect();
    }
    
    // Set the mock adapter profile with the selected scenario
    ObdFactory.profileManager.setManualProfile('mock_elm327');
    
    // Reconnect with the new scenario
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock OBD Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Text('Status: $_status', 
              style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            
            // Connection controls
            Row(
              children: [
                ElevatedButton(
                  onPressed: _obdService.isConnected ? null : _connect,
                  child: const Text('Connect'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _obdService.isConnected ? _disconnect : null,
                  child: const Text('Disconnect'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Scenario selection
            Text('Test Scenario:', 
              style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedScenario,
              onChanged: (value) {
                if (value != null) {
                  _changeScenario(value);
                }
              },
              items: MockTestData.availableScenarios
                  .map((scenario) => DropdownMenuItem(
                        value: scenario,
                        child: Text(scenario.replaceAll('_', ' ')),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            
            // Data display
            Text('OBD Data:', 
              style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: _data.isEmpty
                  ? const Center(child: Text('No data available'))
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final name = _data.keys.elementAt(index);
                        final value = _data[name];
                        return ListTile(
                          title: Text(name),
                          trailing: Text(value ?? 'N/A'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 