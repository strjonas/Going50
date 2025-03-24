import 'dart:convert';

/// Represents a connection between users in the social features system.
/// 
/// This supports REQ-1.4 and REQ-1.8 for social integration and connection tracking.
class SocialConnection {
  final String id;
  final String userId;
  final String connectedUserId;
  final String connectionType; // 'friend', 'following'
  final DateTime connectedSince;
  final bool isMutual;
  
  SocialConnection({
    required this.id,
    required this.userId,
    required this.connectedUserId,
    required this.connectionType,
    required this.connectedSince,
    this.isMutual = false,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'connectedUserId': connectedUserId,
    'connectionType': connectionType,
    'connectedSince': connectedSince.toIso8601String(),
    'isMutual': isMutual,
  };
  
  factory SocialConnection.fromJson(Map<String, dynamic> json) => 
    SocialConnection(
      id: json['id'],
      userId: json['userId'],
      connectedUserId: json['connectedUserId'],
      connectionType: json['connectionType'],
      connectedSince: DateTime.parse(json['connectedSince']),
      isMutual: json['isMutual'] ?? false,
    );
    
  /// Create a copy of this object with the specified fields updated
  SocialConnection copyWith({
    String? id,
    String? userId,
    String? connectedUserId,
    String? connectionType,
    DateTime? connectedSince,
    bool? isMutual,
  }) {
    return SocialConnection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      connectedUserId: connectedUserId ?? this.connectedUserId,
      connectionType: connectionType ?? this.connectionType,
      connectedSince: connectedSince ?? this.connectedSince,
      isMutual: isMutual ?? this.isMutual,
    );
  }
}

/// Represents user interactions with content in the social features system.
/// 
/// This supports tracking likes, comments, and other engagement metrics
/// for social content sharing.
class SocialInteraction {
  final String id;
  final String userId;
  final String contentType; // 'trip', 'achievement', 'milestone'
  final String contentId;
  final String interactionType; // 'like', 'comment', 'share'
  final String? content; // For comments, etc.
  final DateTime timestamp;
  
  SocialInteraction({
    required this.id,
    required this.userId,
    required this.contentType,
    required this.contentId,
    required this.interactionType,
    this.content,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'contentType': contentType,
    'contentId': contentId,
    'interactionType': interactionType,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
  
  factory SocialInteraction.fromJson(Map<String, dynamic> json) => 
    SocialInteraction(
      id: json['id'],
      userId: json['userId'],
      contentType: json['contentType'],
      contentId: json['contentId'],
      interactionType: json['interactionType'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
    
  /// Create a copy of this object with the specified fields updated
  SocialInteraction copyWith({
    String? id,
    String? userId,
    String? contentType,
    String? contentId,
    String? interactionType,
    String? content,
    DateTime? timestamp,
  }) {
    return SocialInteraction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      interactionType: interactionType ?? this.interactionType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Represents content that has been shared by a user through the social system.
/// 
/// This supports REQ-1.4 and REQ-1.8 for content sharing and social features.
class SharedContent {
  final String id;
  final String userId;
  final String contentType; // 'trip', 'achievement', 'ecoScore'
  final String contentId;
  final String shareType; // 'public', 'friends', 'external'
  final String? externalPlatform; // If external, where it was shared
  final String? shareUrl; // Public URL if generated
  final DateTime sharedAt;
  final bool isActive;
  
  SharedContent({
    required this.id,
    required this.userId,
    required this.contentType,
    required this.contentId,
    required this.shareType,
    this.externalPlatform,
    this.shareUrl,
    required this.sharedAt,
    this.isActive = true,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'contentType': contentType,
    'contentId': contentId,
    'shareType': shareType,
    'externalPlatform': externalPlatform,
    'shareUrl': shareUrl,
    'sharedAt': sharedAt.toIso8601String(),
    'isActive': isActive,
  };
  
  factory SharedContent.fromJson(Map<String, dynamic> json) => 
    SharedContent(
      id: json['id'],
      userId: json['userId'],
      contentType: json['contentType'],
      contentId: json['contentId'],
      shareType: json['shareType'],
      externalPlatform: json['externalPlatform'],
      shareUrl: json['shareUrl'],
      sharedAt: DateTime.parse(json['sharedAt']),
      isActive: json['isActive'] ?? true,
    );
    
  /// Create a copy of this object with the specified fields updated
  SharedContent copyWith({
    String? id,
    String? userId,
    String? contentType,
    String? contentId,
    String? shareType,
    String? externalPlatform,
    String? shareUrl,
    DateTime? sharedAt,
    bool? isActive,
  }) {
    return SharedContent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      shareType: shareType ?? this.shareType,
      externalPlatform: externalPlatform ?? this.externalPlatform,
      shareUrl: shareUrl ?? this.shareUrl,
      sharedAt: sharedAt ?? this.sharedAt,
      isActive: isActive ?? this.isActive,
    );
  }
} 