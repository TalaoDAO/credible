import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  Future<void> setLightTheme() async {
    await SecureStorageProvider.instance.set('theme', 'light');
    emit(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await SecureStorageProvider.instance.set('theme', 'dark');
    emit(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await SecureStorageProvider.instance.set('theme', 'system');
    emit(ThemeMode.system);
  }
}

extension ThemeModeX on ThemeMode {
  bool get isLightTheme => this == ThemeMode.light;

  bool get isDarkTheme => this == ThemeMode.dark;

  bool get isSystemTheme => this == ThemeMode.system;
}
