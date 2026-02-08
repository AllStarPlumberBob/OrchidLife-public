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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_florist,
                          color: AppTheme.textOnPrimary.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                            color: AppTheme.textOnPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
