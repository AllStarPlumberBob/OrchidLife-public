import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = <_NavItem>[
    _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, 'Agenda'),
    _NavItem(Icons.local_florist_outlined, Icons.local_florist, 'Orchids'),
    _NavItem(Icons.handyman_outlined, Icons.handyman, 'Tools'),
    _NavItem(Icons.settings_outlined, Icons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(
        left: AppTheme.floatingNavMarginH,
        right: AppTheme.floatingNavMarginH,
        bottom: AppTheme.floatingNavMarginB + bottomPadding,
      ),
      height: AppTheme.floatingNavHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary, AppTheme.sliverGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.floatingNavRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = i == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                splashColor: Colors.white.withValues(alpha: 0.15),
                highlightColor: Colors.white.withValues(alpha: 0.1),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected ? item.selectedIcon : item.icon,
                          size: 24,
                          color: selected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            color: selected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}
