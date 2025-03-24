import 'package:flutter/material.dart';

/// A primary action button with the app's brand color.
/// 
/// This button is used for primary actions in the app.
/// It follows the design system with a specific height,
/// padding, background color, text color, and corner radius.
///
/// Example:
/// ```dart
/// PrimaryButton(
///   onPressed: () {
///     // Handle button press
///   },
///   text: 'Start Trip',
/// )
/// ```
class PrimaryButton extends StatelessWidget {
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
  
  /// Create a primary button with the app's brand styling
  const PrimaryButton({
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
        color: theme.colorScheme.onPrimary,
      ),
    );
    
    if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          buttonContent,
        ],
      );
    }
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: theme.elevatedButtonTheme.style,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          child: buttonContent,
        ),
      ),
    );
  }
} 