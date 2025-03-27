import 'package:flutter/material.dart';
import 'package:going50/services/driving/obd_connection_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/obd_lib/test/obd_field_test.dart';
import 'package:going50/obd_lib/obd_service.dart';

/// A widget that allows configuration of the OBD adapter settings.
class AdapterConfig extends StatefulWidget {
  /// Constructor
  const AdapterConfig({super.key});

  @override
  State<AdapterConfig> createState() => _AdapterConfigState();
}

class _AdapterConfigState extends State<AdapterConfig> {
  late ObdConnectionService _obdService;
  List<Map<String, String>> _availableProfiles = [];
  String? _selectedProfileId;
  bool _isAutoDetectionEnabled = true;
  bool _isAdapterConnected = false;

  @override
  void initState() {
    super.initState();
    _obdService = serviceLocator<ObdConnectionService>();
    _loadProfiles();
    _checkAdapterConnection();
  }

  /// Loads the available adapter profiles
  void _loadProfiles() {
    try {
      setState(() {
        _availableProfiles = _obdService.getAvailableProfiles();
        // Initially use automatic detection 
        _selectedProfileId = null;
        _isAutoDetectionEnabled = true;
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading profiles: $e');
    }
  }

  /// Check if an adapter is currently connected
  void _checkAdapterConnection() {
    setState(() {
      _isAdapterConnected = _obdService.isConnected;
    });
  }

  /// Sets the selected adapter profile
  void _setProfile(String? profileId) {
    if (profileId == null) {
      _obdService.enableAutomaticProfileDetection();
      setState(() {
        _selectedProfileId = null;
        _isAutoDetectionEnabled = true;
      });
    } else {
      _obdService.setAdapterProfile(profileId);
      setState(() {
        _selectedProfileId = profileId;
        _isAutoDetectionEnabled = false;
      });
    }
  }

  /// Navigate to adapter test screen
  void _navigateToAdapterTest() {
    final obdService = serviceLocator<ObdService>();
    final deviceId = _obdService.currentDeviceId;
    
    if (deviceId == null || deviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No adapter connected. Please connect an adapter first.')),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObdFieldTestScreen(
          obdService: obdService,
          deviceId: deviceId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Adapter Configuration',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        
        const SizedBox(height: 16),
        
        // Info text
        Text(
          'Configure advanced settings for your OBD adapter. In most cases, automatic detection works best.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        
        const SizedBox(height: 24),
        
        // Automatic detection option
        _buildProfileOption(
          context, 
          null, 
          'Automatic Detection (Recommended)',
          'The app will automatically detect and use the best protocol for your adapter.',
        ),
        
        const Divider(height: 32),
        
        // Manual profile selection heading
        Text(
          'Manual Profile Selection',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        
        const SizedBox(height: 12),
        
        // Available profiles
        ..._availableProfiles.map((profile) => _buildProfileOption(
          context,
          profile['id'],
          profile['name'] ?? 'Unknown Profile',
          profile['description'] ?? 'No description available',
        )),
        
        if (_availableProfiles.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No profiles available. Connect an OBD device first to see available profiles.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          
        // Add a divider and test adapter section
        const Divider(height: 32),
        
        // Adapter test section
        Text(
          'Adapter Testing',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Test your OBD adapter connection quality, performance, and reliability.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        
        const SizedBox(height: 16),
        
        ElevatedButton.icon(
          onPressed: _isAdapterConnected ? _navigateToAdapterTest : null,
          icon: const Icon(Icons.speed),
          label: const Text('TEST ADAPTER PERFORMANCE'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
          ),
        ),
        
        if (!_isAdapterConnected)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Connect an OBD adapter first to run tests.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  /// Builds a profile option card
  Widget _buildProfileOption(
    BuildContext context,
    String? profileId,
    String title,
    String description,
  ) {
    final isSelected = (profileId == null && _isAutoDetectionEnabled) || 
                       (profileId != null && profileId == _selectedProfileId);
    
    return InkWell(
      onTap: () => _setProfile(profileId),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withAlpha(26)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Radio<String?>(
              value: profileId,
              groupValue: _selectedProfileId,
              onChanged: (value) => _setProfile(value),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
} 