import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  Future<void> setLightTheme() async {
    await SecureStorageProvider.instance.set('theme', 'light');
    setTheme(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await SecureStorageProvider.instance.set('theme', 'dark');
    setTheme(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await SecureStorageProvider.instance.set('theme', 'system');
    setTheme(ThemeMode.system);
  }

  void setTheme(ThemeMode? themeMode) {
    if (themeMode != null) emit(themeMode);
  }
}

extension ThemeModeX on ThemeMode {
  bool get isLightTheme => this == ThemeMode.light;

  bool get isDarkTheme => this == ThemeMode.dark;

  bool get isSystemTheme => this == ThemeMode.system;
}
