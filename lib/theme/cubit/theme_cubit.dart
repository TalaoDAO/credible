import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  Future<void> setLightTheme() async {
    await SecureStorageProvider.instance.set('theme', 'light');
    emit(ThemeMode.light);
  }

  Future<void> setDartTheme() async {
    await SecureStorageProvider.instance.set('theme', 'dark');
    emit(ThemeMode.dark);
  }
}
