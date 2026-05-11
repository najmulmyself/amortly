import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode');
    if (isDark == null) {
      emit(ThemeMode.system);
    } else {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }

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
