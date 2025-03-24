import 'dart:convert';

/// ExternalIntegration represents a connection to an external platform.
/// 
/// This supports REQ-4.8 for integration with ride-sharing platforms
/// and other external services.
class ExternalIntegration {
  final String id;
  final String userId;
  final String platformType; // 'uber', 'lyft', 'applecarplay', etc.
  final String? externalId;
  final String integrationStatus; // 'active', 'pending', 'revoked'
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? integrationData;
  
  ExternalIntegration({
    required this.id,
    required this.userId,
    required this.platformType,
    this.externalId,
    required this.integrationStatus,
    required this.connectedAt,
    this.lastSyncAt,
    this.accessToken,
    this.refreshToken,
    this.integrationData,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'userId': userId,
      'platformType': platformType,
      'externalId': externalId,
      'integrationStatus': integrationStatus,
      'connectedAt': connectedAt.toIso8601String(),
      'lastSyncAt': lastSyncAt?.toIso8601String(),
    };
    
    // Only include tokens in the JSON if they're present
    // In a real app, these would be securely stored or encrypted
    if (accessToken != null) {
      json['accessToken'] = accessToken;
    }
    
    if (refreshToken != null) {
      json['refreshToken'] = refreshToken;
    }
    
    // Encode the integration data as a JSON string if present
    if (integrationData != null) {
      json['integrationData'] = jsonEncode(integrationData);
    }
    
    return json;
  }
  
  factory ExternalIntegration.fromJson(Map<String, dynamic> json) {
    // Parse integration data if present
    Map<String, dynamic>? integrationData;
    if (json['integrationData'] != null) {
      try {
        integrationData = jsonDecode(json['integrationData']);
      } catch (_) {
        integrationData = null;
      }
    }
    
    return ExternalIntegration(
      id: json['id'],
      userId: json['userId'],
      platformType: json['platformType'],
      externalId: json['externalId'],
      integrationStatus: json['integrationStatus'],
      connectedAt: DateTime.parse(json['connectedAt']),
      lastSyncAt: json['lastSyncAt'] != null ? DateTime.parse(json['lastSyncAt']) : null,
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      integrationData: integrationData,
    );
  }
  
  /// Create a copy with tokens updated (e.g., after token refresh)
  ExternalIntegration copyWithUpdatedTokens({
    required String accessToken,
    String? refreshToken,
  }) {
    return ExternalIntegration(
      id: id,
      userId: userId,
      platformType: platformType,
      externalId: externalId,
      integrationStatus: integrationStatus,
      connectedAt: connectedAt,
      lastSyncAt: DateTime.now(),
      accessToken: accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      integrationData: integrationData,
    );
  }
  
  /// Create a copy with status updated
  ExternalIntegration copyWithStatus(String newStatus) {
    return ExternalIntegration(
      id: id,
      userId: userId,
      platformType: platformType,
      externalId: externalId,
      integrationStatus: newStatus,
      connectedAt: connectedAt,
      lastSyncAt: DateTime.now(),
      accessToken: accessToken,
      refreshToken: refreshToken,
      integrationData: integrationData,
    );
  }
  
  /// Create a copy of this object with the specified fields updated
  ExternalIntegration copyWith({
    String? id,
    String? userId,
    String? platformType,
    String? externalId,
    String? integrationStatus,
    DateTime? connectedAt,
    DateTime? lastSyncAt,
    String? accessToken,
    String? refreshToken,
    Map<String, dynamic>? integrationData,
  }) {
    return ExternalIntegration(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      platformType: platformType ?? this.platformType,
      externalId: externalId ?? this.externalId,
      integrationStatus: integrationStatus ?? this.integrationStatus,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      integrationData: integrationData ?? this.integrationData,
    );
  }
}

/// SyncStatus tracks the synchronization status of entities with external systems.
/// 
/// This supports REQ-4.8 by providing a way to track which data has been
/// synchronized with external platforms and the status of those syncs.
class SyncStatus {
  final String id;
  final String userId;
  final String entityType; // 'trip', 'badge', 'challenge', etc.
  final String entityId;
  final String? targetPlatform; // If syncing to specific external platform
  final String syncStatus; // 'pending', 'synced', 'failed'
  final DateTime? lastAttemptAt;
  final int retryCount;
  final String? errorMessage;
  
  SyncStatus({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    this.targetPlatform,
    required this.syncStatus,
    this.lastAttemptAt,
    this.retryCount = 0,
    this.errorMessage,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'entityType': entityType,
    'entityId': entityId,
    'targetPlatform': targetPlatform,
    'syncStatus': syncStatus,
    'lastAttemptAt': lastAttemptAt?.toIso8601String(),
    'retryCount': retryCount,
    'errorMessage': errorMessage,
  };
  
  factory SyncStatus.fromJson(Map<String, dynamic> json) => 
    SyncStatus(
      id: json['id'],
      userId: json['userId'],
      entityType: json['entityType'],
      entityId: json['entityId'],
      targetPlatform: json['targetPlatform'],
      syncStatus: json['syncStatus'],
      lastAttemptAt: json['lastAttemptAt'] != null ? DateTime.parse(json['lastAttemptAt']) : null,
      retryCount: json['retryCount'] ?? 0,
      errorMessage: json['errorMessage'],
    );
  
  /// Mark as pending sync
  SyncStatus markAsPending() {
    return SyncStatus(
      id: id,
      userId: userId,
      entityType: entityType,
      entityId: entityId,
      targetPlatform: targetPlatform,
      syncStatus: 'pending',
      lastAttemptAt: DateTime.now(),
      retryCount: retryCount,
      errorMessage: null,
    );
  }
  
  /// Mark as successfully synced
  SyncStatus markAsSynced() {
    return SyncStatus(
      id: id,
      userId: userId,
      entityType: entityType,
      entityId: entityId,
      targetPlatform: targetPlatform,
      syncStatus: 'synced',
      lastAttemptAt: DateTime.now(),
      retryCount: retryCount,
      errorMessage: null,
    );
  }
  
  /// Mark as failed with error message
  SyncStatus markAsFailed(String error) {
    return SyncStatus(
      id: id,
      userId: userId,
      entityType: entityType,
      entityId: entityId,
      targetPlatform: targetPlatform,
      syncStatus: 'failed',
      lastAttemptAt: DateTime.now(),
      retryCount: retryCount + 1,
      errorMessage: error,
    );
  }
  
  /// Create a copy of this object with the specified fields updated
  SyncStatus copyWith({
    String? id,
    String? userId,
    String? entityType,
    String? entityId,
    String? targetPlatform,
    String? syncStatus,
    DateTime? lastAttemptAt,
    int? retryCount,
    String? errorMessage,
  }) {
    return SyncStatus(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      targetPlatform: targetPlatform ?? this.targetPlatform,
      syncStatus: syncStatus ?? this.syncStatus,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
} 