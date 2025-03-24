import 'dart:convert';

/// Challenge represents a specific goal or task for users.
/// 
/// Challenges can be system-generated or user-created, supporting
/// the gamification requirements in the application.
class Challenge {
  final String id;
  final String title;
  final String description;
  final String type; // 'daily', 'weekly', 'achievement'
  final int targetValue;
  final String metricType; // 'calmDriving', 'idling', etc.
  final bool isSystem;
  final String? creatorId; // If user-created
  final bool isActive;
  final int difficultyLevel; // 1-5
  final String? iconName;
  final String? rewardType; // Points, badge, etc.
  final int rewardValue;
  
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.metricType,
    this.isSystem = true,
    this.creatorId,
    this.isActive = true,
    this.difficultyLevel = 1,
    this.iconName,
    this.rewardType,
    this.rewardValue = 0,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'targetValue': targetValue,
    'metricType': metricType,
    'isSystem': isSystem,
    'creatorId': creatorId,
    'isActive': isActive,
    'difficultyLevel': difficultyLevel,
    'iconName': iconName,
    'rewardType': rewardType,
    'rewardValue': rewardValue,
  };
  
  factory Challenge.fromJson(Map<String, dynamic> json) => 
    Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      targetValue: json['targetValue'],
      metricType: json['metricType'],
      isSystem: json['isSystem'] ?? true,
      creatorId: json['creatorId'],
      isActive: json['isActive'] ?? true,
      difficultyLevel: json['difficultyLevel'] ?? 1,
      iconName: json['iconName'],
      rewardType: json['rewardType'],
      rewardValue: json['rewardValue'] ?? 0,
    );
    
  /// Create a copy of this object with the specified fields updated
  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    int? targetValue,
    String? metricType,
    bool? isSystem,
    String? creatorId,
    bool? isActive,
    int? difficultyLevel,
    String? iconName,
    String? rewardType,
    int? rewardValue,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      metricType: metricType ?? this.metricType,
      isSystem: isSystem ?? this.isSystem,
      creatorId: creatorId ?? this.creatorId,
      isActive: isActive ?? this.isActive,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      iconName: iconName ?? this.iconName,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
    );
  }
}

/// UserChallenge tracks a user's progress on a particular challenge.
/// 
/// This links users to challenges and tracks their completion status.
class UserChallenge {
  final String id;
  final String userId;
  final String challengeId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int progress;
  final bool isCompleted;
  final bool rewardClaimed;
  
  UserChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.startedAt,
    this.completedAt,
    this.progress = 0,
    this.isCompleted = false,
    this.rewardClaimed = false,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'challengeId': challengeId,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'progress': progress,
    'isCompleted': isCompleted,
    'rewardClaimed': rewardClaimed,
  };
  
  factory UserChallenge.fromJson(Map<String, dynamic> json) => 
    UserChallenge(
      id: json['id'],
      userId: json['userId'],
      challengeId: json['challengeId'],
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      progress: json['progress'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      rewardClaimed: json['rewardClaimed'] ?? false,
    );
    
  /// Update progress and check if challenge is now completed
  UserChallenge copyWithProgress(int newProgress, int targetValue) {
    final bool nowComplete = newProgress >= targetValue;
    return UserChallenge(
      id: id,
      userId: userId,
      challengeId: challengeId,
      startedAt: startedAt,
      completedAt: nowComplete && !isCompleted ? DateTime.now() : completedAt,
      progress: newProgress,
      isCompleted: nowComplete,
      rewardClaimed: rewardClaimed,
    );
  }
  
  /// Mark the reward as claimed
  UserChallenge copyWithRewardClaimed() {
    return UserChallenge(
      id: id,
      userId: userId,
      challengeId: challengeId,
      startedAt: startedAt,
      completedAt: completedAt,
      progress: progress, 
      isCompleted: isCompleted,
      rewardClaimed: true,
    );
  }
  
  /// Create a copy of this object with the specified fields updated
  UserChallenge copyWith({
    String? id,
    String? userId,
    String? challengeId,
    DateTime? startedAt,
    DateTime? completedAt,
    int? progress,
    bool? isCompleted,
    bool? rewardClaimed,
  }) {
    return UserChallenge(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
    );
  }
}

/// Streak tracks consecutive activity completion.
/// 
/// This supports maintaining user engagement through streaks of daily/weekly activities.
class Streak {
  final String id;
  final String userId;
  final String streakType; // 'daily_drive', 'eco_score', etc.
  final int currentCount;
  final int bestCount;
  final DateTime lastRecorded;
  final DateTime nextDue;
  final bool isActive;
  
  Streak({
    required this.id,
    required this.userId,
    required this.streakType,
    this.currentCount = 0,
    this.bestCount = 0,
    required this.lastRecorded,
    required this.nextDue,
    this.isActive = true,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'streakType': streakType,
    'currentCount': currentCount,
    'bestCount': bestCount,
    'lastRecorded': lastRecorded.toIso8601String(),
    'nextDue': nextDue.toIso8601String(),
    'isActive': isActive,
  };
  
  factory Streak.fromJson(Map<String, dynamic> json) => 
    Streak(
      id: json['id'],
      userId: json['userId'],
      streakType: json['streakType'],
      currentCount: json['currentCount'] ?? 0,
      bestCount: json['bestCount'] ?? 0,
      lastRecorded: DateTime.parse(json['lastRecorded']),
      nextDue: DateTime.parse(json['nextDue']),
      isActive: json['isActive'] ?? true,
    );
    
  /// Increment the streak when a user completes an activity
  Streak incrementStreak() {
    final now = DateTime.now();
    final newCount = currentCount + 1;
    return Streak(
      id: id,
      userId: userId,
      streakType: streakType,
      currentCount: newCount,
      bestCount: newCount > bestCount ? newCount : bestCount,
      lastRecorded: now,
      nextDue: _calculateNextDue(now, streakType),
      isActive: true,
    );
  }
  
  /// Reset the streak when a user misses an activity
  Streak breakStreak() {
    final now = DateTime.now();
    return Streak(
      id: id,
      userId: userId,
      streakType: streakType,
      currentCount: 0,
      bestCount: bestCount,
      lastRecorded: now,
      nextDue: _calculateNextDue(now, streakType),
      isActive: true,
    );
  }
  
  /// Calculate the next due date based on streak type
  DateTime _calculateNextDue(DateTime current, String type) {
    if (type == 'daily_drive') {
      return DateTime(current.year, current.month, current.day + 1);
    } else if (type == 'weekly_summary') {
      return DateTime(current.year, current.month, current.day + 7);
    }
    // Default to next day
    return DateTime(current.year, current.month, current.day + 1);
  }
  
  /// Create a copy of this object with the specified fields updated
  Streak copyWith({
    String? id,
    String? userId,
    String? streakType,
    int? currentCount,
    int? bestCount,
    DateTime? lastRecorded,
    DateTime? nextDue,
    bool? isActive,
  }) {
    return Streak(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      streakType: streakType ?? this.streakType,
      currentCount: currentCount ?? this.currentCount,
      bestCount: bestCount ?? this.bestCount,
      lastRecorded: lastRecorded ?? this.lastRecorded,
      nextDue: nextDue ?? this.nextDue,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// LeaderboardEntry represents a user's position on a leaderboard.
/// 
/// This supports the social and competitive aspects of the application.
class LeaderboardEntry {
  final String id;
  final String leaderboardType; // 'global', 'regional', 'friends'
  final String timeframe; // 'daily', 'weekly', 'monthly', 'alltime'
  final String userId;
  final String? regionCode; // Optional region
  final int rank;
  final int score;
  final DateTime recordedAt;
  final int daysRetained;
  
  LeaderboardEntry({
    required this.id,
    required this.leaderboardType,
    required this.timeframe,
    required this.userId,
    this.regionCode,
    required this.rank,
    required this.score,
    required this.recordedAt,
    this.daysRetained = 0,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'leaderboardType': leaderboardType,
    'timeframe': timeframe,
    'userId': userId,
    'regionCode': regionCode,
    'rank': rank,
    'score': score,
    'recordedAt': recordedAt.toIso8601String(),
    'daysRetained': daysRetained,
  };
  
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => 
    LeaderboardEntry(
      id: json['id'],
      leaderboardType: json['leaderboardType'],
      timeframe: json['timeframe'],
      userId: json['userId'],
      regionCode: json['regionCode'],
      rank: json['rank'],
      score: json['score'],
      recordedAt: DateTime.parse(json['recordedAt']),
      daysRetained: json['daysRetained'] ?? 0,
    );
    
  /// Create a copy of this object with the specified fields updated
  LeaderboardEntry copyWith({
    String? id,
    String? leaderboardType,
    String? timeframe,
    String? userId,
    String? regionCode,
    int? rank,
    int? score,
    DateTime? recordedAt,
    int? daysRetained,
  }) {
    return LeaderboardEntry(
      id: id ?? this.id,
      leaderboardType: leaderboardType ?? this.leaderboardType,
      timeframe: timeframe ?? this.timeframe,
      userId: userId ?? this.userId,
      regionCode: regionCode ?? this.regionCode,
      rank: rank ?? this.rank,
      score: score ?? this.score,
      recordedAt: recordedAt ?? this.recordedAt,
      daysRetained: daysRetained ?? this.daysRetained,
    );
  }
} 