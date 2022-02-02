import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/theme/theme.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

void main() {
  group('ThemeCubit', () {
    test('initial state is correct', () {
      expect(ThemeCubit().state, ThemeMode.system);
    });

    test('emits [ThemeMode.Light) when setLightTheme is called', () async {
      final themeCubit = ThemeCubit();
      await themeCubit.setLightTheme();
      expect(themeCubit.state, ThemeMode.light);
    });
  });

  ///TODO : How to test secure storage

  group('setTheme', () {
    test('emits correct theme for null', () async {
      final themeCubit = ThemeCubit();
      themeCubit.setTheme(null);
      expect(themeCubit.state, ThemeMode.system);
    });


    test('emits correct theme for ThemeMode.Light', () async {
      final themeCubit = ThemeCubit();
      themeCubit.setTheme(ThemeMode.light);
      expect(themeCubit.state, ThemeMode.light);
    });

    test('emits correct theme for ThemeMode.Dark', () async {
      final themeCubit = ThemeCubit();
      themeCubit.setTheme(ThemeMode.dark);
      expect(themeCubit.state, ThemeMode.dark);
    });

    test('emits correct theme for ThemeMode.System', () async {
      final themeCubit = ThemeCubit();
      themeCubit.setTheme(ThemeMode.system);
      expect(themeCubit.state, ThemeMode.system);
    });
  });
}
