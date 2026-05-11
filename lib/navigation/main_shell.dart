import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(path: '/', icon: Icons.calculate_outlined, activeIcon: Icons.calculate, label: AppStrings.tabCalculator),
    _TabItem(path: '/schedule', icon: Icons.table_rows_outlined, activeIcon: Icons.table_rows, label: AppStrings.tabSchedule),
    _TabItem(path: '/compare', icon: Icons.compare_arrows_outlined, activeIcon: Icons.compare_arrows, label: AppStrings.tabCompare),
    _TabItem(path: '/saved', icon: Icons.bookmark_outline, activeIcon: Icons.bookmark, label: AppStrings.tabSaved),
    _TabItem(path: '/settings', icon: Icons.settings_outlined, activeIcon: Icons.settings, label: AppStrings.tabSettings),
  ];

  int _locationToIndex(String location) {
    if (location.startsWith('/schedule')) return 1;
    if (location.startsWith('/compare')) return 2;
    if (location.startsWith('/saved')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.neutral200,
              width: 0.5, // iOS hairline border
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => context.go(_tabs[index].path),
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: _tabs
                .asMap()
                .entries
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(e.value.icon, size: 22),
                    activeIcon: Icon(e.value.activeIcon, size: 22),
                    label: e.value.label,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabItem({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
