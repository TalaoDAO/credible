import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/theme/theme.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  late SecureStorageProvider mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
  });

  group('ThemeCubit', () {
    test('initial state is correct', () {
      expect(ThemeCubit(mockSecureStorage).state, ThemeMode.system);
    });
  });

  group('setTheme', () {
    test('emits correct theme for null', () async {
      final themeCubit = ThemeCubit(mockSecureStorage);
      themeCubit.setTheme(null);
      expect(themeCubit.state, ThemeMode.system);
    });

    test('emits correct theme for ThemeMode.Light', () async {
      final themeCubit = ThemeCubit(mockSecureStorage);
      themeCubit.setTheme(ThemeMode.light);
      expect(themeCubit.state, ThemeMode.light);
    });

    test('emits correct theme for ThemeMode.Dark', () async {
      final themeCubit = ThemeCubit(mockSecureStorage);
      themeCubit.setTheme(ThemeMode.dark);
      expect(themeCubit.state, ThemeMode.dark);
    });

    test('emits correct theme for ThemeMode.System', () async {
      final themeCubit = ThemeCubit(mockSecureStorage);
      themeCubit.setTheme(ThemeMode.system);
      expect(themeCubit.state, ThemeMode.system);
    });
  });

  group(
    'set correct storage data and respective theme',
    () {
      blocTest<ThemeCubit, ThemeMode>('ThemeMode.Light',
          build: () => ThemeCubit(mockSecureStorage),
          act: (cubit) => cubit.setLightTheme(),
          setUp: () {
            when(
              () => mockSecureStorage.set('theme', 'light'),
            ).thenAnswer((_) async => {});
          },
          expect: () => <ThemeMode>[ThemeMode.light],
          verify: (_) {
            verify(() => mockSecureStorage.set('theme', 'light')).called(1);
          });

      blocTest<ThemeCubit, ThemeMode>('ThemeMode.Dark',
          build: () => ThemeCubit(mockSecureStorage),
          act: (cubit) => cubit.setDarkTheme(),
          setUp: () {
            when(
              () => mockSecureStorage.set('theme', 'dark'),
            ).thenAnswer((_) async => {});
          },
          expect: () => <ThemeMode>[ThemeMode.dark],
          verify: (_) {
            verify(() => mockSecureStorage.set('theme', 'dark')).called(1);
          });

      blocTest<ThemeCubit, ThemeMode>('ThemeMode.System',
          build: () => ThemeCubit(mockSecureStorage),
          act: (cubit) => cubit.setSystemTheme(),
          setUp: () {
            when(
              () => mockSecureStorage.set('theme', 'system'),
            ).thenAnswer((_) async => {});
          },
          expect: () => <ThemeMode>[ThemeMode.system],
          verify: (_) {
            verify(() => mockSecureStorage.set('theme', 'system')).called(1);
          });
    },
  );
}
