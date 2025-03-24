import 'dart:convert';

/// UserPreference represents a single user preference setting.
/// 
/// Preferences are stored as key-value pairs organized by category
/// to support REQ-1.2 for personalization and adaptive feedback.
class UserPreference {
  final String id;
  final String userId;
  final String preferenceCategory; // 'feedback', 'gamification', 'ui', etc.
  final String preferenceName;
  final dynamic preferenceValue;
  final DateTime updatedAt;
  
  UserPreference({
    required this.id,
    required this.userId,
    required this.preferenceCategory,
    required this.preferenceName,
    required this.preferenceValue,
    required this.updatedAt,
  });
  
  Map<String, dynamic> toJson() {
    var valueToStore = preferenceValue;
    
    // Ensure complex objects are properly JSON encoded
    if (preferenceValue != null && 
        preferenceValue is! String && 
        preferenceValue is! num && 
        preferenceValue is! bool) {
      valueToStore = jsonEncode(preferenceValue);
    }
    
    return {
      'id': id,
      'userId': userId,
      'preferenceCategory': preferenceCategory,
      'preferenceName': preferenceName,
      'preferenceValue': valueToStore,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  factory UserPreference.fromJson(Map<String, dynamic> json) {
    var value = json['preferenceValue'];
    
    // Try to decode JSON string values
    if (value is String) {
      try {
        value = jsonDecode(value);
      } catch (_) {
        // Not a JSON string, use as is
      }
    }
    
    return UserPreference(
      id: json['id'],
      userId: json['userId'],
      preferenceCategory: json['preferenceCategory'],
      preferenceName: json['preferenceName'],
      preferenceValue: value,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Create a copy of this object with the specified fields updated
  UserPreference copyWith({
    String? id,
    String? userId,
    String? preferenceCategory,
    String? preferenceName,
    dynamic preferenceValue,
    DateTime? updatedAt,
  }) {
    return UserPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      preferenceCategory: preferenceCategory ?? this.preferenceCategory,
      preferenceName: preferenceName ?? this.preferenceName,
      preferenceValue: preferenceValue ?? this.preferenceValue,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// FeedbackEffectiveness tracks how different feedback types affect user behavior.
/// 
/// This supports REQ-1.2 for adaptive personalization by measuring which
/// feedback approaches work best for each user and driving behavior.
class FeedbackEffectiveness {
  final String id;
  final String userId;
  final String feedbackType; // 'gentle_reminder', 'direct_instruction', 'positive_reinforcement'
  final String drivingBehaviorType; // 'acceleration', 'speed', 'idling', etc.
  final int timesDelivered;
  final int timesBehaviorImproved;
  final double effectivenessRatio;
  final DateTime lastUpdated;
  
  FeedbackEffectiveness({
    required this.id,
    required this.userId,
    required this.feedbackType,
    required this.drivingBehaviorType,
    this.timesDelivered = 0,
    this.timesBehaviorImproved = 0,
    this.effectivenessRatio = 0.0,
    required this.lastUpdated,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'feedbackType': feedbackType,
    'drivingBehaviorType': drivingBehaviorType,
    'timesDelivered': timesDelivered,
    'timesBehaviorImproved': timesBehaviorImproved,
    'effectivenessRatio': effectivenessRatio,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
  
  factory FeedbackEffectiveness.fromJson(Map<String, dynamic> json) => 
    FeedbackEffectiveness(
      id: json['id'],
      userId: json['userId'],
      feedbackType: json['feedbackType'],
      drivingBehaviorType: json['drivingBehaviorType'],
      timesDelivered: json['timesDelivered'] ?? 0,
      timesBehaviorImproved: json['timesBehaviorImproved'] ?? 0,
      effectivenessRatio: json['effectivenessRatio'] ?? 0.0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
    
  /// Create a copy when feedback was given and behavior improved
  FeedbackEffectiveness copyWithImprovement() {
    final newTimesDelivered = timesDelivered + 1;
    final newTimesBehaviorImproved = timesBehaviorImproved + 1;
    
    return FeedbackEffectiveness(
      id: id,
      userId: userId,
      feedbackType: feedbackType,
      drivingBehaviorType: drivingBehaviorType,
      timesDelivered: newTimesDelivered,
      timesBehaviorImproved: newTimesBehaviorImproved,
      effectivenessRatio: newTimesBehaviorImproved / newTimesDelivered,
      lastUpdated: DateTime.now(),
    );
  }
  
  /// Create a copy when feedback was given but behavior did not improve
  FeedbackEffectiveness copyWithNoImprovement() {
    final newTimesDelivered = timesDelivered + 1;
    
    return FeedbackEffectiveness(
      id: id,
      userId: userId,
      feedbackType: feedbackType,
      drivingBehaviorType: drivingBehaviorType,
      timesDelivered: newTimesDelivered,
      timesBehaviorImproved: timesBehaviorImproved,
      effectivenessRatio: timesBehaviorImproved / newTimesDelivered,
      lastUpdated: DateTime.now(),
    );
  }
  
  /// Create a copy of this object with the specified fields updated
  FeedbackEffectiveness copyWith({
    String? id,
    String? userId,
    String? feedbackType,
    String? drivingBehaviorType,
    int? timesDelivered,
    int? timesBehaviorImproved,
    double? effectivenessRatio,
    DateTime? lastUpdated,
  }) {
    return FeedbackEffectiveness(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      feedbackType: feedbackType ?? this.feedbackType,
      drivingBehaviorType: drivingBehaviorType ?? this.drivingBehaviorType,
      timesDelivered: timesDelivered ?? this.timesDelivered,
      timesBehaviorImproved: timesBehaviorImproved ?? this.timesBehaviorImproved,
      effectivenessRatio: effectivenessRatio ?? this.effectivenessRatio,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
} 