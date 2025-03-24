import 'package:flutter/material.dart';

/// A container for sections of content with consistent styling.
///
/// This component provides a standardized way to layout sections
/// with optional titles, padding, and consistent spacing.
///
/// Example:
/// ```dart
/// SectionContainer(
///   title: 'Recent Trips',
///   child: ListView(
///     children: [
///       // List items
///     ],
///   ),
/// )
/// ```
class SectionContainer extends StatelessWidget {
  /// Optional title for the section
  final String? title;
  
  /// The content to display in the section
  final Widget child;
  
  /// Optional background color for the section
  final Color? backgroundColor;
  
  /// Optional padding to apply to the section contents
  final EdgeInsetsGeometry padding;
  
  /// Optional margin to apply around the container
  final EdgeInsetsGeometry margin;
  
  /// Whether to add a divider at the top of the section
  final bool topDivider;
  
  /// Whether to add a divider at the bottom of the section
  final bool bottomDivider;
  
  /// Optional action widget to display next to the title (e.g., "See All" button)
  final Widget? action;
  
  /// Create a section container with the app's styling
  const SectionContainer({
    super.key,
    this.title,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 16),
    this.topDivider = false,
    this.bottomDivider = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        boxShadow: backgroundColor != null 
            ? null 
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(13), // ~0.05 opacity
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topDivider) Divider(height: 1, thickness: 1, color: theme.dividerTheme.color),
          
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.only(
                left: padding.horizontal / 2,
                right: padding.horizontal / 2,
                top: padding.vertical / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
          ],
          
          Padding(
            padding: title != null 
                ? EdgeInsets.only(
                    left: padding.horizontal / 2,
                    right: padding.horizontal / 2,
                    top: padding.vertical / 4,
                    bottom: padding.vertical / 2,
                  ) 
                : padding,
            child: child,
          ),
          
          if (bottomDivider) Divider(height: 1, thickness: 1, color: theme.dividerTheme.color),
        ],
      ),
    );
  }
}

/// Extension to get horizontal and vertical padding from EdgeInsetsGeometry
extension EdgeInsetsGeometryExtension on EdgeInsetsGeometry {
  /// The horizontal padding value
  double get horizontal {
    if (this is EdgeInsets) {
      final EdgeInsets edgeInsets = this as EdgeInsets;
      return edgeInsets.left + edgeInsets.right;
    }
    return 32; // Default if not EdgeInsets
  }
  
  /// The vertical padding value
  double get vertical {
    if (this is EdgeInsets) {
      final EdgeInsets edgeInsets = this as EdgeInsets;
      return edgeInsets.top + edgeInsets.bottom;
    }
    return 32; // Default if not EdgeInsets
  }
} 