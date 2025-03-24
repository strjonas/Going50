import 'dart:async';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:going50/core_models/data_privacy_settings.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PrivacyService manages user privacy settings and data access control
///
/// This service is responsible for:
/// - Managing privacy settings for different data types
/// - Checking permissions for data operations
/// - Enforcing data access controls
/// - Broadcasting privacy setting changes
class PrivacyService {
  // Dependencies
  final DataStorageManager _dataStorageManager;
  
  // Logging
  final _log = Logger('PrivacyService');
  
  // State
  final Map<String, DataPrivacySettings> _privacySettings = {};
  String? _currentUserId;
  final _privacyStreamController = StreamController<Map<String, DataPrivacySettings>>.broadcast();
  
  // Constants for data types
  static const String dataTypeTrips = 'trips';
  static const String dataTypeLocation = 'location';
  static const String dataTypeDrivingEvents = 'driving_events';
  static const String dataTypePerformanceMetrics = 'performance_metrics';
  
  // Constants for operations
  static const String operationLocalStorage = 'local_storage';
  static const String operationCloudSync = 'cloud_sync';
  static const String operationSharing = 'sharing';
  static const String operationAnalytics = 'analytics';
  
  // UUID generator
  final _uuid = const Uuid();
  
  /// Constructor
  PrivacyService(this._dataStorageManager);
  
  /// Initialize the service
  Future<void> initialize() async {
    _log.info('Initializing PrivacyService');
    await _loadCurrentUserId();
    await _loadPrivacySettings();
  }
  
  /// Get the map of privacy settings
  Map<String, DataPrivacySettings> get privacySettings => 
      Map.unmodifiable(_privacySettings);
  
  /// Stream of privacy setting updates
  Stream<Map<String, DataPrivacySettings>> get privacySettingsStream => 
      _privacyStreamController.stream;
  
  /// Load the current user ID
  Future<void> _loadCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('user_id');
      _log.info('Current user ID: $_currentUserId');
    } catch (e) {
      _log.severe('Error loading current user ID: $e');
      rethrow;
    }
  }
  
  /// Load privacy settings for the current user
  Future<void> _loadPrivacySettings() async {
    if (_currentUserId == null) {
      _log.warning('Cannot load privacy settings: No user ID');
      return;
    }
    
    try {
      final settings = await _dataStorageManager.getDataPrivacySettings();
      _privacySettings.clear();
      
      for (final setting in settings) {
        _privacySettings[setting.dataType] = setting;
      }
      
      _log.info('Loaded ${settings.length} privacy settings');
      
      // If we don't have all required data types, create default settings
      await _ensureDefaultSettings();
      
      // Notify listeners
      _notifyListeners();
    } catch (e) {
      _log.severe('Error loading privacy settings: $e');
    }
  }
  
  /// Ensure default settings exist for all data types
  Future<void> _ensureDefaultSettings() async {
    final requiredDataTypes = [
      dataTypeTrips,
      dataTypeLocation,
      dataTypeDrivingEvents,
      dataTypePerformanceMetrics,
    ];
    
    for (final dataType in requiredDataTypes) {
      if (!_privacySettings.containsKey(dataType)) {
        await _createDefaultSetting(dataType);
      }
    }
  }
  
  /// Create a default setting for a data type
  Future<void> _createDefaultSetting(String dataType) async {
    if (_currentUserId == null) return;
    
    final setting = DataPrivacySettings(
      id: _uuid.v4(),
      userId: _currentUserId!,
      dataType: dataType,
      // Default settings - allow local storage but not sync or sharing
      allowLocalStorage: true,
      allowCloudSync: false,
      allowSharing: false,
      allowAnonymizedAnalytics: true,
    );
    
    _log.info('Creating default privacy setting for $dataType');
    
    await _dataStorageManager.saveDataPrivacySettings(setting);
    _privacySettings[dataType] = setting;
  }
  
  /// Get privacy setting for a specific data type
  Future<DataPrivacySettings?> getSettingForDataType(String dataType) async {
    // If in cache, return from cache
    if (_privacySettings.containsKey(dataType)) {
      return _privacySettings[dataType];
    }
    
    // Otherwise try to load from storage
    try {
      final setting = await _dataStorageManager.getDataPrivacySettingForType(dataType);
      if (setting != null) {
        _privacySettings[dataType] = setting;
      }
      return setting;
    } catch (e) {
      _log.warning('Error getting privacy setting for $dataType: $e');
      return null;
    }
  }
  
  /// Update privacy setting for a data type
  Future<bool> updatePrivacySetting({
    required String dataType,
    bool? allowLocalStorage,
    bool? allowCloudSync,
    bool? allowSharing,
    bool? allowAnonymizedAnalytics,
  }) async {
    if (_currentUserId == null) {
      _log.warning('Cannot update privacy setting: No user ID');
      return false;
    }
    
    try {
      // Get existing setting or create new one
      final existingSetting = await getSettingForDataType(dataType);
      
      final updatedSetting = existingSetting != null 
          ? existingSetting.copyWith(
              allowLocalStorage: allowLocalStorage,
              allowCloudSync: allowCloudSync,
              allowSharing: allowSharing,
              allowAnonymizedAnalytics: allowAnonymizedAnalytics,
            )
          : DataPrivacySettings(
              id: _uuid.v4(),
              userId: _currentUserId!,
              dataType: dataType,
              allowLocalStorage: allowLocalStorage ?? true,
              allowCloudSync: allowCloudSync ?? false,
              allowSharing: allowSharing ?? false,
              allowAnonymizedAnalytics: allowAnonymizedAnalytics ?? true,
            );
      
      // Save to storage
      await _dataStorageManager.saveDataPrivacySettings(updatedSetting);
      
      // Update cache
      _privacySettings[dataType] = updatedSetting;
      
      // Notify listeners
      _notifyListeners();
      
      _log.info('Updated privacy setting for $dataType');
      return true;
    } catch (e) {
      _log.severe('Error updating privacy setting for $dataType: $e');
      return false;
    }
  }
  
  /// Check if an operation is allowed for a data type
  Future<bool> isOperationAllowed(String dataType, String operation) async {
    try {
      final setting = await getSettingForDataType(dataType);
      if (setting == null) {
        // If no setting exists, use safe defaults
        return operation == operationLocalStorage;
      }
      
      switch (operation) {
        case operationLocalStorage:
          return setting.allowLocalStorage;
        case operationCloudSync:
          return setting.allowCloudSync;
        case operationSharing:
          return setting.allowSharing;
        case operationAnalytics:
          return setting.allowAnonymizedAnalytics;
        default:
          _log.warning('Unknown operation: $operation');
          return false;
      }
    } catch (e) {
      _log.warning('Error checking if operation $operation is allowed for $dataType: $e');
      return false;
    }
  }
  
  /// Reset privacy settings to defaults
  Future<bool> resetToDefaults() async {
    if (_currentUserId == null) {
      _log.warning('Cannot reset privacy settings: No user ID');
      return false;
    }
    
    try {
      _privacySettings.clear();
      await _ensureDefaultSettings();
      _notifyListeners();
      _log.info('Reset privacy settings to defaults');
      return true;
    } catch (e) {
      _log.severe('Error resetting privacy settings: $e');
      return false;
    }
  }
  
  /// Check if all required privacy settings exist
  Future<bool> checkPrivacySettingsComplete() async {
    if (_currentUserId == null) return false;
    
    final requiredDataTypes = [
      dataTypeTrips,
      dataTypeLocation,
      dataTypeDrivingEvents,
      dataTypePerformanceMetrics,
    ];
    
    // Check if all required data types have settings
    for (final dataType in requiredDataTypes) {
      final setting = await getSettingForDataType(dataType);
      if (setting == null) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Handle user changes - reload settings when user changes
  Future<void> handleUserChanged(String? userId) async {
    if (userId != _currentUserId) {
      _currentUserId = userId;
      await _loadPrivacySettings();
    }
  }
  
  /// Notify listeners of changes
  void _notifyListeners() {
    if (!_privacyStreamController.isClosed) {
      _privacyStreamController.add(Map.unmodifiable(_privacySettings));
    }
  }
  
  /// Dispose resources
  void dispose() {
    _privacyStreamController.close();
  }
} 