import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  /// Pass the initial [ThemeMode] read from SharedPreferences in main()
  /// so the cubit never emits during the first build frame.
  AppThemeCubit(super.initialMode);

  Future<void> setLight() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', false);
    emit(ThemeMode.light);
  }

  Future<void> setDark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', true);
    emit(ThemeMode.dark);
  }

  Future<void> setSystem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dark_mode');
    emit(ThemeMode.system);
  }

  void toggle() {
    if (state == ThemeMode.dark) {
      setLight();
    } else {
      setDark();
    }
  }
}
