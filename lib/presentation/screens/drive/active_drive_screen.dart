import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/screens/drive/components/eco_score_display.dart';
import 'package:going50/presentation/screens/drive/components/current_metrics_strip.dart';
import 'package:going50/presentation/screens/drive/components/event_notification.dart';
import 'package:going50/core_models/driving_event.dart';

/// ActiveDriveScreen is the distraction-minimized screen shown during active driving.
///
/// This screen provides real-time feedback on driving performance while minimizing
/// distractions. It features a large eco-score, essential metrics, and event notifications.
class ActiveDriveScreen extends StatefulWidget {
  const ActiveDriveScreen({super.key});

  @override
  State<ActiveDriveScreen> createState() => _ActiveDriveScreenState();
}

class _ActiveDriveScreenState extends State<ActiveDriveScreen> with WidgetsBindingObserver {
  // Event notification display
  DrivingEvent? _currentEvent;
  Timer? _eventTimer;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Set preferred orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set system UI to immersive mode during driving
    _setImmersiveMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    // Reset orientation constraints
    SystemChrome.setPreferredOrientations([]);
    
    // Reset system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    _eventTimer?.cancel();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When app is resumed, reset immersive mode
      _setImmersiveMode();
    }
  }
  
  // Set immersive mode to minimize distractions
  void _setImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  
  void _showEventNotification(DrivingEvent event) {
    setState(() {
      _currentEvent = event;
    });
    
    // Clear previous timer if it exists
    _eventTimer?.cancel();
    
    // Set a timer to clear the notification after 3 seconds
    _eventTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentEvent = null;
        });
      }
    });
  }
  
  void _endTrip(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    final success = await drivingProvider.endTrip();
    
    if (!mounted) return;
    
    if (success) {
      // Navigate to trip summary screen
      navigator.pushReplacementNamed(DriveRoutes.tripSummary);
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to end trip. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrivingProvider>(
      builder: (context, drivingProvider, child) {
        // Listen for driving events
        if (drivingProvider.recentEvents.isNotEmpty && 
            _currentEvent != drivingProvider.recentEvents.first) {
          _showEventNotification(drivingProvider.recentEvents.first);
        }
        
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                // Main content
                Column(
                  children: [
                    // Status bar with minimal info
                    _buildStatusBar(context, drivingProvider),
                    
                    // Main eco-score display (takes most of the screen)
                    Expanded(
                      flex: 7,
                      child: EcoScoreDisplay(
                        ecoScore: drivingProvider.currentEcoScore,
                      ),
                    ),
                    
                    // Current metrics strip at bottom
                    Expanded(
                      flex: 2,
                      child: CurrentMetricsStrip(
                        onEndTripTap: () => _endTrip(context),
                      ),
                    ),
                  ],
                ),
                
                // Event notification overlay (conditionally shown)
                if (_currentEvent != null)
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: EventNotification(
                      event: _currentEvent!,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatusBar(BuildContext context, DrivingProvider drivingProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(178),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Trip duration
          Text(
            drivingProvider.currentTrip?.startTime != null 
                ? _formatDuration(DateTime.now().difference(drivingProvider.currentTrip!.startTime!))
                : '00:00',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Exit button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => _endTrip(context),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
} 