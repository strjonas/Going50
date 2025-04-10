import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/presentation/screens/drive/components/connection_status_widget.dart';
import 'package:going50/presentation/screens/drive/components/start_trip_button.dart';
import 'package:going50/presentation/screens/drive/components/recent_trip_card.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/permission_service.dart';

/// DriveScreen is the main screen for the Drive tab.
///
/// This screen provides access to trip recording functionality and displays
/// connection status as well as recent trip information.
class DriveScreen extends StatefulWidget {
  const DriveScreen({super.key});

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  bool _audioFeedbackEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    final drivingProvider = Provider.of<DrivingProvider>(context);
    final insightsProvider = Provider.of<InsightsProvider>(context);
    final currentEcoScore = drivingProvider.currentEcoScore;
    final ecoScoreColor = AppColors.getEcoScoreColor(currentEcoScore);
    final isFirstUse = insightsProvider.recentTrips.isEmpty;
    final mostRecentTrip = insightsProvider.recentTrips.isNotEmpty 
        ? insightsProvider.recentTrips.first 
        : null;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status section (30% of the screen)
              Expanded(
                flex: 3,
                child: _buildStatusSection(
                  context, 
                  drivingProvider, 
                  currentEcoScore, 
                  ecoScoreColor
                ),
              ),
              
              // Action section (40% of the screen)
              Expanded(
                flex: 4,
                child: _buildActionSection(
                  context, 
                  drivingProvider
                ),
              ),
              
              // Quick stats section (30% of the screen)
              Expanded(
                flex: 3,
                child: _buildQuickStatsSection(
                  context, 
                  isFirstUse, 
                  mostRecentTrip
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the status section with connection status and eco-score
  Widget _buildStatusSection(
    BuildContext context, 
    DrivingProvider drivingProvider,
    double currentEcoScore,
    Color ecoScoreColor,
  ) {
    final statusMessage = _getStatusMessage(drivingProvider);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Connection status
          const ConnectionStatusWidget(),
          
          const SizedBox(height: 16),
          
          // Latest eco-score
          if (drivingProvider.isObdConnected || drivingProvider.isCollecting)
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ecoScoreColor.withOpacity(0.1),
                    border: Border.all(
                      color: ecoScoreColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      currentEcoScore.toInt().toString(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ecoScoreColor,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Status message
                Text(
                  statusMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  /// Builds the action section with Start Trip button
  Widget _buildActionSection(BuildContext context, DrivingProvider drivingProvider) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start trip button
            StartTripButton(
              size: 100,
              onBeforeStart: () async {
                // Show an explanation dialog about permissions and wait for user to acknowledge
                // before proceeding with permission requests
                bool? dialogResult = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // User must take an action
                  builder: (context) => AlertDialog(
                    title: const Text('Required Permissions'),
                    content: const Text(
                      'Going50 needs access to your location and motion sensors to track your trip. '
                      'Bluetooth access may also be requested for OBD connectivity. '
                      'These permissions are only used while you are actively recording a trip.'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                );
                
                // If user didn't confirm, stop the flow by throwing an exception
                // The StartTripButton will catch this and not proceed
                if (dialogResult != true) {
                  throw Exception('Permission dialog canceled by user');
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Device connection shortcut (if not connected)
            if (!drivingProvider.isObdConnected)
              TextButton.icon(
                onPressed: () {
                  // Navigate to device connection screen
                  Navigator.of(context).pushNamed(ProfileRoutes.deviceConnection);
                },
                icon: const Icon(Icons.bluetooth),
                label: const Text('Connect OBD Device'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                ),
              ),
              
            const SizedBox(height: 24),
            
            // Audio feedback toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Audio Feedback',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _audioFeedbackEnabled,
                  onChanged: (value) {
                    setState(() {
                      _audioFeedbackEnabled = value;
                    });
                    // TODO: Implement audio feedback toggle in driving provider
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds the quick stats section with recent trip or first use card
  Widget _buildQuickStatsSection(
    BuildContext context, 
    bool isFirstUse, 
    Trip? mostRecentTrip,
  ) {
    if (isFirstUse) {
      return _buildFirstUseCard(context);
    } else if (mostRecentTrip != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Recent Trip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RecentTripCard(
              trip: mostRecentTrip,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Trip details not yet implemented'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Pull for more',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
  
  /// Builds a card for first-time users
  Widget _buildFirstUseCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_car,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              const Text(
                'Welcome to Going50!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Start your first trip to begin tracking your eco-driving performance.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to onboarding guide or help
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help not yet implemented'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Learn More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Gets an appropriate status message based on the current driving state
  String _getStatusMessage(DrivingProvider drivingProvider) {
    if (drivingProvider.isRecording) {
      return 'Trip in progress';
    } else if (drivingProvider.isObdConnected) {
      return 'Ready to drive';
    } else if (drivingProvider.isCollecting) {
      return 'Using phone sensors';
    } else if (drivingProvider.errorMessage != null) {
      return 'Connection error';
    } else {
      return 'Connect device to start';
    }
  }
} 