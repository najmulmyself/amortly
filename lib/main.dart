import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_cubit.dart';
import 'navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  // Read saved theme before runApp so AppThemeCubit never emits during build,
  // which would violate the debugFrameWasSentToEngine assertion.
  final prefs = await SharedPreferences.getInstance();
  final savedDark = prefs.getBool('dark_mode');
  final initialTheme = savedDark == null
      ? ThemeMode.system
      : (savedDark ? ThemeMode.dark : ThemeMode.light);

  // TODO(storage): await Hive.initFlutter() when storage layer is wired
  // TODO(att): AppTrackingTransparency prompt before App Store submission
  runApp(AmortlyApp(initialTheme: initialTheme));
}

class AmortlyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  const AmortlyApp({super.key, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppThemeCubit(initialTheme),
      child: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Amortly',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: appRouter,
            scrollBehavior: const _IOSScrollBehavior(),
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
