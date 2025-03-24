
/// DataPrivacySettings defines user preferences for privacy controls on various data types.
///
/// This model enables granular control over how different types of data are stored,
/// shared, and analyzed, supporting REQ-5.4 for privacy controls.
class DataPrivacySettings {
  final String id;
  final String userId;
  final String dataType; // 'trips', 'location', 'driving_events', etc.
  final bool allowLocalStorage;
  final bool allowCloudSync;
  final bool allowSharing;
  final bool allowAnonymizedAnalytics;
  
  DataPrivacySettings({
    required this.id,
    required this.userId,
    required this.dataType,
    this.allowLocalStorage = true,
    this.allowCloudSync = false,
    this.allowSharing = false,
    this.allowAnonymizedAnalytics = true,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'dataType': dataType,
    'allowLocalStorage': allowLocalStorage,
    'allowCloudSync': allowCloudSync,
    'allowSharing': allowSharing,
    'allowAnonymizedAnalytics': allowAnonymizedAnalytics,
  };
  
  factory DataPrivacySettings.fromJson(Map<String, dynamic> json) => 
    DataPrivacySettings(
      id: json['id'],
      userId: json['userId'],
      dataType: json['dataType'],
      allowLocalStorage: json['allowLocalStorage'] ?? true,
      allowCloudSync: json['allowCloudSync'] ?? false,
      allowSharing: json['allowSharing'] ?? false,
      allowAnonymizedAnalytics: json['allowAnonymizedAnalytics'] ?? true,
    );
    
  /// Create a copy of this object with the specified fields updated
  DataPrivacySettings copyWith({
    String? id,
    String? userId,
    String? dataType,
    bool? allowLocalStorage,
    bool? allowCloudSync,
    bool? allowSharing,
    bool? allowAnonymizedAnalytics,
  }) {
    return DataPrivacySettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dataType: dataType ?? this.dataType,
      allowLocalStorage: allowLocalStorage ?? this.allowLocalStorage,
      allowCloudSync: allowCloudSync ?? this.allowCloudSync,
      allowSharing: allowSharing ?? this.allowSharing,
      allowAnonymizedAnalytics: allowAnonymizedAnalytics ?? this.allowAnonymizedAnalytics,
    );
  }
} 