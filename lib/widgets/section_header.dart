import 'package:flutter/material.dart';

/// Shared section header with icon + title, used in detail screens and settings.
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
