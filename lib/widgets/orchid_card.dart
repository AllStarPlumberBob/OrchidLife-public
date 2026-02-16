import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrchidCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  /// Optional gradient header strip above the child content.
  /// When provided, [headerPadding] controls header insets and
  /// [child] padding applies only to the body below the header.
  final GradientHeader? header;

  const OrchidCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final body = header != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ],
          )
        : Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          );

    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      clipBehavior: header != null ? Clip.antiAlias : Clip.none,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              child: body,
            )
          : body,
    );
  }

  Widget _buildHeader() {
    final h = header!;
    return Container(
      padding: h.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [h.gradientStart, h.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: h.child,
    );
  }
}

/// Describes a gradient header strip for [OrchidCard].
class GradientHeader {
  final Color gradientStart;
  final Color gradientEnd;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GradientHeader({
    required this.gradientStart,
    required this.gradientEnd,
    required this.child,
    this.padding,
  });
}
