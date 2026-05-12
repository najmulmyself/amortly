import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(
        path: '/',
        icon: 'assets/icons/calculator.png',
        label: AppStrings.tabCalculator),
    _TabItem(
        path: '/schedule',
        icon: 'assets/icons/calendar.png',
        label: AppStrings.tabSchedule),
    _TabItem(
        path: '/compare-ab',
        icon: 'assets/icons/compare.png',
        label: AppStrings.tabCompare),
    _TabItem(
        path: '/saved',
        icon: 'assets/icons/saved.png',
        label: AppStrings.tabSaved),
    _TabItem(
        path: '/settings',
        icon: 'assets/icons/settings.png',
        label: AppStrings.tabSettings),
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
              width: 0.5,
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
            items: _tabs.asMap().entries.map((e) {
              final selected = e.key == currentIndex;
              final color = selected
                  ? AppColors.brand700
                  : (isDark ? AppColors.neutral400 : AppColors.neutral500);
              final iconWidget = Image.asset(
                e.value.icon,
                width: 24,
                height: 24,
                color: color,
              );
              return BottomNavigationBarItem(
                icon: iconWidget,
                label: e.value.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String path;
  final String icon;
  final String label;

  const _TabItem({
    required this.path,
    required this.icon,
    required this.label,
  });
}
