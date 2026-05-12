import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_cubit.dart';
import 'features/calculator/cubit/calculator_cubit.dart';
import 'features/saved/cubit/saved_cubit.dart';
import 'navigation/app_router.dart';
import 'services/ad_service.dart';
import 'services/purchase_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Hive
  await StorageService().init();

  // 2. Pro status (must be before AdService so ads aren't loaded for Pro users)
  await PurchaseService().loadProStatus();

  // 3. ATT prompt — must happen before first ad request on iOS 14.5+
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // 4. AdMob (after ATT)
  await AdService().initialize();

  // 5. Cache onboarding flag once — avoids async SharedPrefs on every route change
  final onboardingDone = await StorageService().isOnboardingComplete();

  final prefs = await SharedPreferences.getInstance();
  final savedDark = prefs.getBool('dark_mode');
  final initialTheme = savedDark == null
      ? ThemeMode.system
      : (savedDark ? ThemeMode.dark : ThemeMode.light);

  runApp(AmortlyApp(initialTheme: initialTheme, onboardingDone: onboardingDone));
}

class AmortlyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  final bool onboardingDone;
  const AmortlyApp({super.key, required this.initialTheme, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppThemeCubit(initialTheme)),
        BlocProvider(create: (_) => CalculatorCubit()),
        BlocProvider(create: (_) => SavedCubit()),
      ],
      child: ListenableBuilder(
        listenable: PurchaseService(),
        builder: (context, _) {
          return BlocBuilder<AppThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Amortly',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                routerConfig: buildAppRouter(onboardingDone),
                scrollBehavior: const _IOSScrollBehavior(),
              );
            },
          );
        },
      ),
    );
  }
}

/// Applies [BouncingScrollPhysics] globally for an iOS-native scroll feel.
class _IOSScrollBehavior extends ScrollBehavior {
  const _IOSScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
