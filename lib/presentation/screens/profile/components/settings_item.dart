import 'package:flutter/material.dart';

/// A settings item component for use in the settings screen.
///
/// This component displays a single settings option with a title,
/// optional subtitle, optional icon, and optional trailing widget.
class SettingsItem extends StatelessWidget {
  /// The title of the settings item.
  final String title;

  /// The optional subtitle/description text.
  final String? subtitle;

  /// The optional leading icon.
  final IconData? icon;

  /// The optional trailing widget (e.g., toggle, arrow).
  final Widget? trailing;

  /// The callback function when the item is tapped.
  final VoidCallback? onTap;

  /// The background color of the settings item.
  final Color? backgroundColor;

  /// Whether to show a divider after this item.
  final bool showDivider;

  /// Constructor for the settings item.
  const SettingsItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
} 