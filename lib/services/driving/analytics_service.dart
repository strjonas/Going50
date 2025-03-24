import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/behavior_classifier_lib/managers/eco_driving_manager.dart';
import 'package:logging/logging.dart';

/// Service that analyzes driving behavior data and provides insights
///
/// This service is responsible for:
/// - Analyzing driving data using the behavior classifier
/// - Calculating eco-score based on driving patterns
/// - Detecting driving behavior events
/// - Generating real-time feedback on driving
class AnalyticsService extends ChangeNotifier {
  final Logger _logger = Logger('AnalyticsService');
  
  // Dependencies
  final EcoDrivingManager _ecoDrivingManager;
  
  // Service state
  bool _isInitialized = false;
  String? _errorMessage;
  
  // Analysis results
  double _currentEcoScore = 0.0;
  Map<String, dynamic>? _lastDetailedAnalysis;
  final List<DrivingBehaviorEvent> _recentEvents = [];
  final int _maxEventHistory = 50;
  
  // Stream controllers
  final StreamController<DrivingBehaviorEvent> _eventStreamController = 
      StreamController<DrivingBehaviorEvent>.broadcast();
  final StreamController<double> _ecoScoreStreamController = 
      StreamController<double>.broadcast();
  
  // Timers
  Timer? _analysisTimer;
  final int _analysisIntervalMs = 2000; // Analyze every 2 seconds
  
  // Thresholds for event detection
  static const double _eventSeverityThreshold = 0.6; // Events with severity > 0.6 get reported
  
  // Public getters
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  double get currentEcoScore => _currentEcoScore;
  Map<String, dynamic>? get lastDetailedAnalysis => _lastDetailedAnalysis;
  List<DrivingBehaviorEvent> get recentEvents => List.unmodifiable(_recentEvents);
  
  /// Stream of detected driving behavior events
  Stream<DrivingBehaviorEvent> get eventStream => _eventStreamController.stream;
  
  /// Stream of eco-score updates
  Stream<double> get ecoScoreStream => _ecoScoreStreamController.stream;
  
  /// Constructor
  AnalyticsService(this._ecoDrivingManager) {
    _logger.info('AnalyticsService initialized');
  }
  
  /// Initialize the analytics service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    _logger.info('Initializing analytics service');
    
    try {
      // Set up periodic analysis
      _startPeriodicAnalysis();
      
      _isInitialized = true;
      _clearErrorMessage();
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage('Failed to initialize: $e');
      _logger.severe('Initialization error: $e');
      return false;
    }
  }
  
  /// Start periodic analysis of driving data
  void _startPeriodicAnalysis() {
    // Cancel existing timer if it exists
    _analysisTimer?.cancel();
    
    // Create new timer for analysis
    _analysisTimer = Timer.periodic(
      Duration(milliseconds: _analysisIntervalMs),
      (_) => _performAnalysis()
    );
    
    _logger.info('Started periodic analysis');
  }
  
  /// Stop periodic analysis
  void stopAnalysis() {
    _analysisTimer?.cancel();
    _analysisTimer = null;
    _logger.info('Stopped periodic analysis');
  }
  
  /// Perform analysis of current driving data
  void _performAnalysis() {
    try {
      // Calculate eco-score
      double newScore = _ecoDrivingManager.calculateOverallScore();
      
      // Only update and notify if score has changed significantly
      if ((newScore - _currentEcoScore).abs() > 0.5) {
        _currentEcoScore = newScore;
        _ecoScoreStreamController.add(_currentEcoScore);
        notifyListeners();
      }
      
      // Get detailed analysis
      final detailedAnalysis = _ecoDrivingManager.getDetailedAnalysis();
      _lastDetailedAnalysis = detailedAnalysis;
      
      // Check for events that need reporting
      _detectAndReportEvents(detailedAnalysis);
      
    } catch (e) {
      _logger.warning('Error during analysis: $e');
    }
  }
  
  /// Manually trigger analysis (for cases where periodic analysis is not running)
  Future<void> triggerAnalysis() async {
    _performAnalysis();
  }
  
  /// Detect events from analysis results and report them
  void _detectAndReportEvents(Map<String, dynamic> analysis) {
    final detailedScores = analysis['detailedScores'] as Map<String, dynamic>;
    
    // Check each behavior category for events
    detailedScores.forEach((key, value) {
      // Skip if we don't have full details
      if (value is! Map<String, dynamic>) return;
      
      final score = value['score'] as double? ?? 100.0;
      final confidence = value['confidence'] as double? ?? 0.0;
      final message = value['message'] as String?;
      final details = value['details'] as Map<String, dynamic>?;
      
      // Only consider high-confidence detections
      if (confidence < 0.7) return;
      
      // Low score (high severity) and high confidence means a significant event
      final severity = (100.0 - score) / 100.0;
      if (severity > _eventSeverityThreshold && message != null) {
        final event = DrivingBehaviorEvent(
          timestamp: DateTime.now(),
          behaviorType: key,
          severity: severity,
          message: message,
          details: details,
        );
        
        // Add to recent events
        _addEvent(event);
        
        // Emit the event
        _eventStreamController.add(event);
      }
    });
  }
  
  /// Add an event to recent events list with overflow protection
  void _addEvent(DrivingBehaviorEvent event) {
    _recentEvents.add(event);
    
    // Truncate list if too large
    while (_recentEvents.length > _maxEventHistory) {
      _recentEvents.removeAt(0);
    }
    
    notifyListeners();
  }
  
  /// Get all events during a specified time range
  List<DrivingBehaviorEvent> getEventsInTimeRange(DateTime start, DateTime end) {
    return _recentEvents.where((event) {
      return event.timestamp.isAfter(start) && event.timestamp.isBefore(end);
    }).toList();
  }
  
  /// Get feedback suggestions based on recent driving patterns
  List<FeedbackSuggestion> generateFeedbackSuggestions() {
    List<FeedbackSuggestion> suggestions = [];
    
    // Don't generate suggestions if we don't have detailed analysis
    if (_lastDetailedAnalysis == null) return suggestions;
    
    final detailedScores = _lastDetailedAnalysis!['detailedScores'] as Map<String, dynamic>;
    
    // Check each behavior category for areas of improvement
    detailedScores.forEach((key, value) {
      // Skip if we don't have full details
      if (value is! Map<String, dynamic>) return;
      
      final score = value['score'] as double? ?? 100.0;
      final confidence = value['confidence'] as double? ?? 0.0;
      
      // Only consider high-confidence detections
      if (confidence < 0.6) return;
      
      // For areas with score < 70, generate suggestion
      if (score < 70.0) {
        String suggestion;
        String benefit;
        
        switch (key) {
          case 'calmDriving':
            suggestion = 'Try to accelerate and brake more gently';
            benefit = 'Smoother driving can improve fuel efficiency by up to 30%';
            break;
          case 'speedOptimization':
            suggestion = 'Maintain a steady speed between 50-80 km/h when possible';
            benefit = 'Optimal speed ranges use fuel more efficiently';
            break;
          case 'idling':
            suggestion = 'Consider turning off the engine when stopped for more than 30 seconds';
            benefit = 'Reducing idling can save up to 2% in fuel consumption';
            break;
          case 'shortDistance':
            suggestion = 'Consider combining multiple short trips into one journey';
            benefit = 'Cold engines use more fuel and produce more emissions';
            break;
          case 'rpmManagement':
            suggestion = 'Try shifting gears earlier to keep RPM lower';
            benefit = 'Lower RPM generally means better fuel efficiency';
            break;
          case 'stopManagement':
            suggestion = 'Try to anticipate stops and coast to a stop when possible';
            benefit = 'Reduces fuel usage and brake wear';
            break;
          case 'followDistance':
            suggestion = 'Maintain a larger distance from the vehicle ahead';
            benefit = 'Allows for smoother driving patterns and better anticipation';
            break;
          default:
            suggestion = 'Continue monitoring your driving patterns';
            benefit = 'Regular attention to driving habits improves efficiency';
        }
        
        suggestions.add(FeedbackSuggestion(
          category: key,
          suggestion: suggestion,
          benefit: benefit,
          priority: _calculatePriority(score),
        ));
      }
    });
    
    // Sort by priority
    suggestions.sort((a, b) => b.priority.compareTo(a.priority));
    
    return suggestions;
  }
  
  /// Calculate priority of a suggestion based on score
  int _calculatePriority(double score) {
    if (score < 40.0) return 3; // High priority
    if (score < 60.0) return 2; // Medium priority
    return 1; // Low priority
  }
  
  /// Set error message
  void _setErrorMessage(String message) {
    _errorMessage = message;
    _logger.warning(message);
    notifyListeners();
  }
  
  /// Clear error message
  void _clearErrorMessage() {
    _errorMessage = null;
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _logger.info('Disposing analytics service');
    
    // Stop analysis
    stopAnalysis();
    
    // Close stream controllers
    _eventStreamController.close();
    _ecoScoreStreamController.close();
    
    super.dispose();
  }
}

/// Represents a driving behavior event detected during analysis
class DrivingBehaviorEvent {
  final DateTime timestamp;
  final String behaviorType;
  final double severity; // 0.0 to 1.0
  final String message;
  final Map<String, dynamic>? details;
  
  DrivingBehaviorEvent({
    required this.timestamp,
    required this.behaviorType,
    required this.severity,
    required this.message,
    this.details,
  });
  
  @override
  String toString() {
    return '$behaviorType (${(severity * 100).toStringAsFixed(1)}%): $message';
  }
}

/// Represents a feedback suggestion for the user
class FeedbackSuggestion {
  final String category;
  final String suggestion;
  final String benefit;
  final int priority; // 1 (low) to 3 (high)
  
  FeedbackSuggestion({
    required this.category,
    required this.suggestion,
    required this.benefit,
    required this.priority,
  });
} 