import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_cubit.dart';
import 'navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(storage): await Hive.initFlutter() when storage layer is wired
  // TODO(ads): await MobileAds.instance.initialize() before AdMob go-live
  // TODO(att): AppTrackingTransparency prompt before App Store submission
  runApp(const AmortlyApp());
}

class AmortlyApp extends StatelessWidget {
  const AmortlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppThemeCubit(),
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
