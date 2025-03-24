import 'package:flutter/material.dart';

/// Status indicator types that determine the visual appearance
enum StatusType {
  /// For successful operations or good status
  success,
  
  /// For caution or pending operations
  warning,
  
  /// For errors or critical issues
  error,
  
  /// For informational or neutral status
  info,
  
  /// For inactive or disabled status
  inactive
}

/// A status indicator pill that displays the current status with an icon and text.
///
/// This component follows the design system with specific styling for different
/// status types (success, warning, error, info, inactive).
///
/// Example:
/// ```dart
/// StatusIndicator(
///   type: StatusType.success,
///   text: 'Connected',
///   icon: Icons.bluetooth_connected,
/// )
/// ```
class StatusIndicator extends StatelessWidget {
  /// The type of status to display
  final StatusType type;
  
  /// The text to display inside the pill
  final String text;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Optional custom background color to override the default
  final Color? backgroundColor;
  
  /// Optional custom text color to override the default
  final Color? textColor;
  
  /// Create a status indicator with the app's styling
  const StatusIndicator({
    super.key,
    required this.type,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default colors based on status type
    final Color defaultBgColor = _getBackgroundColor(theme, type);
    final Color defaultTextColor = _getTextColor(theme, type);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: textColor ?? defaultTextColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor ?? defaultTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Returns the background color for a given status type
  Color _getBackgroundColor(ThemeData theme, StatusType type) {
    switch (type) {
      case StatusType.success:
        return theme.colorScheme.primary.withAlpha(38); // ~0.15 opacity
      case StatusType.warning:
        return const Color(0xFFFF9800).withAlpha(38); // ~0.15 opacity
      case StatusType.error:
        return theme.colorScheme.error.withAlpha(38); // ~0.15 opacity
      case StatusType.info:
        return theme.colorScheme.secondary.withAlpha(38); // ~0.15 opacity
      case StatusType.inactive:
        return const Color(0xFF9E9E9E).withAlpha(38); // ~0.15 opacity
    }
  }
  
  /// Returns the text color for a given status type
  Color _getTextColor(ThemeData theme, StatusType type) {
    switch (type) {
      case StatusType.success:
        return theme.colorScheme.primary;
      case StatusType.warning:
        return const Color(0xFFFF9800); // Warning color
      case StatusType.error:
        return theme.colorScheme.error;
      case StatusType.info:
        return theme.colorScheme.secondary;
      case StatusType.inactive:
        return const Color(0xFF9E9E9E); // Gray
    }
  }
} 