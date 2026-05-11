import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/calculator/screens/calculator_screen.dart';
import '../features/schedule/screens/schedule_screen.dart';
import '../features/compare/screens/compare_screen.dart';
import '../features/saved/screens/saved_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/extra_payment/screens/extra_payment_screen.dart';
import '../features/affordability/screens/affordability_screen.dart';
import 'main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const CalculatorScreen(),
        ),
        GoRoute(
          path: '/schedule',
          builder: (_, __) => const ScheduleScreen(),
        ),
        GoRoute(
          path: '/compare',
          builder: (_, __) => const CompareScreen(),
        ),
        GoRoute(
          path: '/saved',
          builder: (_, __) => const SavedScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/extra-payment',
      builder: (_, __) => const ExtraPaymentScreen(),
    ),
    GoRoute(
      path: '/affordability',
      builder: (_, __) => const AffordabilityScreen(),
    ),
  ],
);
