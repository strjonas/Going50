## Core Models Structure

The data model is organized into several key areas:

1. **Trip Tracking**: Records individual journeys with detailed metrics
2. **Driving Data**: Captures OBD-II and phone sensor data during trips
3. **User Management**: Handles user profiles and preferences
4. **Performance Analysis**: Analyzes driving patterns and provides feedback
5. **Gamification**: Implements challenges, badges, and streaks to encourage engagement
6. **Social Features**: Enables social connections and content sharing
7. **Privacy Controls**: Manages user data privacy preferences

## Model Relationships

![Data Model Relationships](https://mermaid.ink/img/pako:eNqFVE1v2zAM_SuETj2sPrRpgGGnDTm0QzegQC7GLAe2RcdCZcmQ5LRB0f8-ynaSuEE3X0z-PJGPpE7KWQ9Kqo5S9H47vXMm5wQ9vMbI-PbA2HEKLjE3thfgwwdmsadX_AYWe91fHx6Z3znN3c33N3Y0hsTdrHlHWr8FOMiYuYWxQw8eIvuPKZDZpoBkPn54vLm-aS5QmcgWmINhM2LZpR9o6D0m1skzJBzCaHSCCXpvfWUyvf-qDKV9Yjx46E3S0NXmXBvcWdOPHScXxjRZYRrNOV-OXtCFZL1GzYnZ7TDIHcRjYEfX3x1XuHOz1FPRCLvzaV5JdGu8nS00sUuRpzlDRGfynNu15xO6Rss_JUEw09ZZXyTGdASHHdoVfXaGc-3-D8bsECOHYx2XLnLqDbtI3rLjMGQKFgXZY0wctHPejkOKWNXBJ4Xx8BoiCVWjWpwgmhxrPfHKaDbOrSYPu4jZWYOZXdBQ63O5lKGQw2a1Uo3dLlRnxZVb9BCMw_6Sjp44LAvxOsjdXvnVwkJXwJUtFB0GF2aSP7QqS12V6gPV2_Fv0j0KXIUe8wI_XKqgdMfPchldmFnOQ0NvLSUYvs2sNfiYhSmQh0_vVUJFqiKqoYrXoTKqLWZ-WrwQspUFxVZVQXpPT2O_oGNV8LMuTF6JdF63jcuzcpFVZSkOtfS-WOWJ7Xpx-G2oDt-P7ZGjXOoKZXXIZ0QlpymXopuSajjJSmVcveFXJNKZyuKrKE6TH3-8RPE4_ewYK-YDFWWpDrgvCZUumvtj1KQYLKmRq5TnedwGFzZFDyW_OgYVuSDnNe989mKO6_JkJd9_QfIf)

## Detailed Model Descriptions

### 1. Trip Related Models

#### Trip
- **Description**: Represents a single journey taken by a user
- **Key Attributes**:
  - `id`: Unique identifier
  - `startTime`: When the trip began
  - `endTime`: When the trip ended
  - `distanceKm`: Total distance traveled
  - `averageSpeedKmh`: Average speed
  - `maxSpeedKmh`: Maximum speed reached
  - `fuelUsedL`: Estimated fuel consumption
  - Various event counters (idling, aggressive acceleration, etc.)
  - `isCompleted`: Whether the trip has ended
  - `ecoScore`: Overall eco-efficiency score
  - `routeDataJson`: Geographical route data
  - `userId`: Reference to the user who took the trip

#### TripDataPoint
- **Description**: Time-series data recorded during a trip
- **Key Attributes**:
  - `tripId`: Reference to the trip
  - `timestamp`: When the data point was recorded
  - `latitude` & `longitude`: Location coordinates
  - `speed`: Vehicle speed in km/h
  - `acceleration`: Vehicle acceleration in m/s²
  - `rpm`: Engine RPM
  - `throttlePosition`: Accelerator position in percentage
  - `engineLoad`: Engine load in percentage
  - `fuelRate`: Fuel consumption rate in L/h
  - `rawDataJson`: Additional data in JSON format

#### DrivingEvent
- **Description**: Significant events detected during driving
- **Key Attributes**:
  - `tripId`: Reference to the trip
  - `timestamp`: When the event occurred
  - `eventType`: Type of event (e.g., hard braking, aggressive acceleration)
  - `severity`: How severe the event was (0.0 to 1.0)
  - `latitude` & `longitude`: Location where the event occurred
  - `detailsJson`: Additional event details in JSON format

### 2. User Management Models

#### UserProfile
- **Description**: Represents a user of the application
- **Key Attributes**:
  - `id`: Unique identifier
  - `name`: User's name
  - `createdAt`: Account creation date
  - `lastUpdatedAt`: Last profile update date
  - `isPublic`: Whether the profile is publicly visible
  - `allowDataUpload`: Whether the user allows data to be uploaded
  - `preferencesJson`: User preferences in JSON format

#### DataPrivacySettings
- **Description**: User's privacy preferences for different data types
- **Key Attributes**:
  - `userId`: Reference to the user
  - `dataType`: Type of data (trips, location, driving events, etc.)
  - `allowLocalStorage`: Whether data can be stored locally
  - `allowCloudSync`: Whether data can be synced to the cloud
  - `allowSharing`: Whether data can be shared with others
  - `allowAnonymizedAnalytics`: Whether anonymized data can be used for analytics

#### UserPreferences
- **Description**: Detailed user preferences for various app features
- **Key Attributes**:
  - `userId`: Reference to the user
  - `preferenceCategory`: Category of preference (feedback, gamification, UI, etc.)
  - `preferenceName`: Name of the specific preference
  - `preferenceValue`: Value of the preference in JSON format
  - `updatedAt`: When the preference was last updated

### 3. Performance Analysis Models

#### PerformanceMetrics
- **Description**: Aggregated driving performance data over a period
- **Key Attributes**:
  - `userId`: Reference to the user
  - `generatedAt`: When the metrics were calculated
  - `periodStart` & `periodEnd`: Time range for the metrics
  - `totalTrips`: Number of trips in the period
  - `totalDistanceKm`: Total distance driven
  - `totalDrivingTimeMinutes`: Total time spent driving
  - Various score metrics (calm driving, speed optimization, etc.)
  - `overallScore`: Overall eco-driving score
  - `improvementTipsJson`: Personalized tips for improvement

#### FeedbackEffectiveness
- **Description**: Tracks how effective different types of feedback are for a user
- **Key Attributes**:
  - `userId`: Reference to the user
  - `feedbackType`: Type of feedback (gentle reminder, direct instruction, etc.)
  - `drivingBehaviorType`: Behavior targeted by the feedback
  - `timesDelivered`: How many times the feedback was given
  - `timesBehaviorImproved`: How many times the behavior improved after feedback
  - `effectivenessRatio`: Ratio of improvement to delivery
  - `lastUpdated`: When the record was last updated

### 4. Gamification Models

#### Challenge
- **Description**: Represents a challenge that users can undertake
- **Key Attributes**:
  - `title`: Name of the challenge
  - `description`: What the challenge involves
  - `type`: Type of challenge (daily, weekly, achievement)
  - `targetValue`: Target to achieve for completion
  - `metricType`: What metric is being measured
  - `isSystem`: Whether it's a system challenge or user-created
  - `creatorId`: Reference to the creator if user-created
  - `difficultyLevel`: How difficult the challenge is (1-5)
  - `rewardType` & `rewardValue`: What the user gets for completing it

#### UserChallenge
- **Description**: Tracks a user's progress on a specific challenge
- **Key Attributes**:
  - `userId`: Reference to the user
  - `challengeId`: Reference to the challenge
  - `startedAt`: When the user started the challenge
  - `completedAt`: When the user completed the challenge
  - `progress`: Current progress toward completion
  - `isCompleted`: Whether the challenge is complete
  - `rewardClaimed`: Whether the reward has been claimed

#### Badge
- **Description**: Represents achievements earned by users
- **Key Attributes**:
  - `userId`: Reference to the user
  - `badgeType`: Type of badge (eco master, smooth driver, etc.)
  - `earnedDate`: When the badge was earned
  - `level`: Level of the badge (1+)
  - `metadataJson`: Additional badge information

#### Streak
- **Description**: Tracks consecutive activity completion
- **Key Attributes**:
  - `userId`: Reference to the user
  - `streakType`: Type of streak (daily drive, eco score, etc.)
  - `currentCount`: Current streak count
  - `bestCount`: Best streak ever achieved
  - `lastRecorded`: When the streak was last updated
  - `nextDue`: When the next activity is due to maintain the streak
  - `isActive`: Whether the streak is currently active

#### LeaderboardEntry
- **Description**: Represents a user's position on a leaderboard
- **Key Attributes**:
  - `leaderboardType`: Type of leaderboard (global, regional, friends)
  - `timeframe`: Time period (daily, weekly, monthly, all-time)
  - `userId`: Reference to the user
  - `regionCode`: Optional region for regional leaderboards
  - `rank`: User's position on the leaderboard
  - `score`: User's score
  - `recordedAt`: When the entry was recorded
  - `daysRetained`: How many days the rank has been maintained

### 5. Social Feature Models

#### SocialConnection
- **Description**: Represents a connection between users
- **Key Attributes**:
  - `userId`: Reference to the user
  - `connectedUserId`: Reference to the connected user
  - `connectionType`: Type of connection (friend, following)
  - `connectedSince`: When the connection was established
  - `isMutual`: Whether the connection is mutual

#### SocialInteraction
- **Description**: Represents interactions with content
- **Key Attributes**:
  - `userId`: Reference to the user
  - `contentType`: Type of content (trip, achievement, milestone)
  - `contentId`: Reference to the content
  - `interactionType`: Type of interaction (like, comment, share)
  - `content`: Text content for comments
  - `timestamp`: When the interaction occurred

#### SharedContent
- **Description**: Represents content shared by a user
- **Key Attributes**:
  - `userId`: Reference to the user
  - `contentType`: Type of content (trip, achievement, eco score)
  - `contentId`: Reference to the content
  - `shareType`: How it was shared (public, friends, external)
  - `externalPlatform`: If shared externally, where it was shared
  - `shareUrl`: Public URL if generated
  - `sharedAt`: When it was shared
  - `isActive`: Whether the share is still active

### 6. External Integration Models

#### ExternalIntegration
- **Description**: Represents a connection to an external platform
- **Key Attributes**:
  - `userId`: Reference to the user
  - `platformType`: Type of platform (Uber, Lyft, Apple CarPlay, etc.)
  - `externalId`: User ID on the external platform
  - `integrationStatus`: Status of the integration (active, pending, revoked)
  - `connectedAt`: When the integration was established
  - `lastSyncAt`: When data was last synced
  - `accessToken` & `refreshToken`: Authentication tokens
  - `integrationDataJson`: Platform-specific settings

#### SyncStatus
- **Description**: Tracks synchronization status for entities
- **Key Attributes**:
  - `userId`: Reference to the user
  - `entityType`: Type of entity (trip, badge, challenge, etc.)
  - `entityId`: Reference to the entity
  - `targetPlatform`: Platform being synced to
  - `syncStatus`: Status of the sync (pending, synced, failed)
  - `lastAttemptAt`: When sync was last attempted
  - `retryCount`: Number of retry attempts
  - `errorMessage`: Error message if sync failed

## Database Schema

The database is implemented using the drift package (formerly moor), which provides type-safe database access for Flutter applications. The database schema includes tables for all the models described above, with appropriate relationships between them.