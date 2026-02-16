import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrchidSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final double expandedHeight;
  final bool showBackButton;
  final Widget? flexibleContent;

  const OrchidSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.expandedHeight = AppTheme.sliverExpandedHeight,
    this.showBackButton = false,
    this.flexibleContent,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      automaticallyImplyLeading: showBackButton,
      backgroundColor: AppTheme.sliverGradientStart,
      foregroundColor: AppTheme.textOnPrimary,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.only(
          left: showBackButton ? 56 : 16,
          bottom: 16,
          right: 16,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textOnPrimary,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.sliverGradientStart,
                AppTheme.sliverGradientEnd,
              ],
            ),
          ),
          child: flexibleContent ??
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 48),
                  child: Icon(
                    Icons.local_florist,
                    color: AppTheme.textOnPrimary.withValues(alpha: 0.08),
                    size: 72,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
