import 'package:flutter/material.dart';

/// A card that displays informational content with optional icon.
///
/// This card follows the design system with specific padding,
/// corner radius, elevation, and text styles.
///
/// Example:
/// ```dart
/// InfoCard(
///   title: 'Eco-Driving Tip',
///   content: 'Avoid aggressive acceleration to improve fuel efficiency.',
///   icon: Icons.lightbulb_outline,
///   onTap: () {
///     // Handle card tap
///   },
/// )
/// ```
class InfoCard extends StatelessWidget {
  /// The title of the card
  final String title;
  
  /// The main content text of the card
  final String content;
  
  /// Optional icon to display with the title
  final IconData? icon;
  
  /// Optional image to display at the top of the card
  final Widget? image;
  
  /// Optional callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Whether the card has a border
  final bool hasBorder;
  
  /// Optional custom padding override
  final EdgeInsetsGeometry? padding;
  
  /// Create an info card with the app's styling
  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.image,
    this.onTap,
    this.hasBorder = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null) ...[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: image!,
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
    
    return Card(
      elevation: hasBorder ? 0 : 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: hasBorder 
            ? BorderSide(color: theme.dividerColor, width: 1) 
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: cardContent,
        ),
      ),
    );
  }
} 