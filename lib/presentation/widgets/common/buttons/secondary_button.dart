import 'package:flutter/material.dart';

/// A secondary action button with transparent background and outlined border.
/// 
/// This button is used for secondary actions in the app.
/// It follows the design system with a specific height,
/// padding, transparent background, primary color text, and corner radius.
///
/// Example:
/// ```dart
/// SecondaryButton(
///   onPressed: () {
///     // Handle button press
///   },
///   text: 'Cancel',
/// )
/// ```
class SecondaryButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// The callback function when the button is pressed
  final VoidCallback? onPressed;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Whether the button should take the full width available
  final bool fullWidth;
  
  /// Optional custom padding override
  final EdgeInsetsGeometry? padding;
  
  /// Create a secondary button with the app's brand styling
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buttonContent = Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
    
    if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          buttonContent,
        ],
      );
    }
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: theme.outlinedButtonTheme.style,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          child: buttonContent,
        ),
      ),
    );
  }
} 