import 'package:intl/intl.dart';
import 'dart:math' as math;

/// A utility class for formatting various data types for display
class FormatterUtils {
  /// Format a date to a readable string
  static String formatDate(DateTime date, {String format = 'MMM d, yyyy'}) {
    return DateFormat(format).format(date);
  }
  
  /// Format a date and time to a readable string
  static String formatDateTime(DateTime dateTime, {String format = 'MMM d, yyyy - HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }
  
  /// Format a time to a readable string
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }
  
  /// Format a duration to a readable string (e.g., "1h 30m")
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    
    String result = '';
    
    // Add hours if greater than 0
    if (duration.inHours > 0) {
      result += '${duration.inHours}h ';
    }
    
    // Add minutes
    result += '${twoDigits(duration.inMinutes.remainder(60))}m';
    
    return result;
  }
  
  /// Format a duration in seconds to a readable string (e.g., "1:30")
  static String formatDurationInSeconds(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds.remainder(60);
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  /// Format a distance in kilometers with 1 decimal place
  static String formatDistance(double? kilometers, {bool includeUnit = true}) {
    if (kilometers == null) return '--';
    
    final formatter = NumberFormat('0.0');
    return includeUnit ? '${formatter.format(kilometers)} km' : formatter.format(kilometers);
  }
  
  /// Format a speed in km/h with 0 decimal places
  static String formatSpeed(double? kmPerHour, {bool includeUnit = true}) {
    if (kmPerHour == null) return '--';
    
    final formatter = NumberFormat('0');
    return includeUnit ? '${formatter.format(kmPerHour)} km/h' : formatter.format(kmPerHour);
  }
  
  /// Format fuel in liters with 2 decimal places
  static String formatFuel(double? liters, {bool includeUnit = true}) {
    if (liters == null) return '--';
    
    final formatter = NumberFormat('0.00');
    return includeUnit ? '${formatter.format(liters)} L' : formatter.format(liters);
  }
  
  /// Format fuel consumption in L/100km with 1 decimal place
  static String formatFuelConsumption(double? litersPer100Km, {bool includeUnit = true}) {
    if (litersPer100Km == null) return '--';
    
    final formatter = NumberFormat('0.0');
    return includeUnit ? '${formatter.format(litersPer100Km)} L/100km' : formatter.format(litersPer100Km);
  }
  
  /// Format a percentage value with 0 decimal places
  static String formatPercentage(double? percentage) {
    if (percentage == null) return '--';
    
    final formatter = NumberFormat('0');
    return '${formatter.format(percentage)}%';
  }
  
  /// Format an eco-score (0-100) with appropriate styling guidance
  static String formatEcoScore(int? score) {
    if (score == null) return '--';
    
    return score.toString();
  }
  
  /// Get color for eco-score
  /// Returns a string representation of a color based on the score
  /// Can be used with Color.fromARGB or similar
  static String getEcoScoreColorString(int score) {
    if (score >= 80) {
      return '#4CAF50'; // Green for excellent
    } else if (score >= 60) {
      return '#8BC34A'; // Light green for good
    } else if (score >= 40) {
      return '#FFC107'; // Amber for average
    } else if (score >= 20) {
      return '#FF9800'; // Orange for below average
    } else {
      return '#F44336'; // Red for poor
    }
  }
  
  /// Format a currency amount
  static String formatCurrency(double? amount, {String currencySymbol = '\$'}) {
    if (amount == null) return '--';
    
    final formatter = NumberFormat('#,##0.00');
    return '$currencySymbol${formatter.format(amount)}';
  }
  
  /// Format a file size in bytes to human-readable format
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (math.log(bytes) / math.log(1024)).floor();
    
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(1)} ${units[i]}';
  }
} 