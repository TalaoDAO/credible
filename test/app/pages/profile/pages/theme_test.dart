import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talao/app/pages/profile/pages/theme.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';

import '../../../../helper/pump_app.dart';

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  late ThemeCubit themeCubit;

  setUp(() {
    themeCubit = MockThemeCubit();
    when(() => themeCubit.state).thenReturn(ThemeMode.system);
  });

  group('ThemePage', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  ThemePage.route(themeCubit),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(ThemePage), findsOneWidget);
    });

    ///TODO
    testWidgets('calls setLightTheme when setLightTheme is Tapped',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(value: themeCubit, child: ThemePage()),
      );
      await tester.tap(find.byKey(const Key('set_light_theme')));
      await tester.pumpAndSettle();
      //verify(() => ThemeCubit().setLightTheme()).called(1);
    });
  });
}
