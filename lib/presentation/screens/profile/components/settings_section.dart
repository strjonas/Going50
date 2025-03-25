import 'package:flutter/material.dart';

/// A settings section component for use in the settings screen.
///
/// This component groups related settings items under a common header.
class SettingsSection extends StatelessWidget {
  /// The title of the settings section.
  final String title;

  /// The list of widgets to display in this section.
  final List<Widget> children;

  /// The margin around the section.
  final EdgeInsets margin;

  /// The background color of the section.
  final Color? backgroundColor;

  /// Whether to show a divider after the section.
  final bool showDivider;

  /// Constructor for the settings section.
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.margin = const EdgeInsets.only(bottom: 24),
    this.backgroundColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          
          // Section content
          Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: children,
            ),
          ),
          
          // Optional section divider
          if (showDivider)
            const Divider(
              height: 32,
              thickness: 1,
            ),
        ],
      ),
    );
  }
} 