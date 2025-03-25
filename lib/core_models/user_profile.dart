import 'dart:convert';

/// UserProfile represents a user of the application
/// 
/// This model stores basic information about the user
/// and their privacy preferences.
class UserProfile {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final bool isPublic;
  final bool allowDataUpload;
  final Map<String, dynamic>? preferences;
  
  // Firebase-related fields
  final String? firebaseId;  // Firebase User UID
  final String? email;       // User email address
  
  /// Constructor
  UserProfile({
    required this.id,
    required this.name,
    required this.createdAt,
    DateTime? lastUpdatedAt,
    required this.isPublic,
    required this.allowDataUpload,
    this.preferences,
    this.firebaseId,
    this.email,
  }) : lastUpdatedAt = lastUpdatedAt ?? createdAt;
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'isPublic': isPublic,
      'allowDataUpload': allowDataUpload,
      'preferencesJson': preferences != null ? jsonEncode(preferences) : null,
      'firebaseId': firebaseId,
      'email': email,
    };
  }
  
  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Parse preferences JSON if it exists
    Map<String, dynamic>? prefsMap;
    if (json['preferencesJson'] != null) {
      try {
        prefsMap = jsonDecode(json['preferencesJson']) as Map<String, dynamic>;
      } catch (e) {
        // Ignore parsing errors, just use null
      }
    }
    
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? 'Anonymous',
      createdAt: json['createdAt'] != null ? 
          DateTime.parse(json['createdAt']) : 
          DateTime.now(),
      lastUpdatedAt: json['lastUpdatedAt'] != null ? 
          DateTime.parse(json['lastUpdatedAt']) : 
          null,
      isPublic: json['isPublic'] ?? false,
      allowDataUpload: json['allowDataUpload'] ?? false,
      preferences: prefsMap,
      firebaseId: json['firebaseId'],
      email: json['email'],
    );
  }
  
  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isPublic,
    bool? allowDataUpload,
    Map<String, dynamic>? preferences,
    String? firebaseId,
    String? email,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isPublic: isPublic ?? this.isPublic,
      allowDataUpload: allowDataUpload ?? this.allowDataUpload,
      preferences: preferences ?? this.preferences,
      firebaseId: firebaseId ?? this.firebaseId,
      email: email ?? this.email,
    );
  }
} 