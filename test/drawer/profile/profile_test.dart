import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/theme/theme.dart';

import '../../helper/pump_app.dart';

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  late ProfileCubit profileCubit;
  late ThemeCubit themeCubit;

  setUp(() {
    profileCubit = MockProfileCubit();
    when(() => profileCubit.state).thenReturn(
      ProfileStateDefault(model: ProfileModel.empty),
    );
    themeCubit = MockThemeCubit();
  });

  group('ProfilePage', () {
    testWidgets('renders ProfileView', (tester) async {
      await tester.pumpApp(
          BlocProvider.value(value: profileCubit, child: ProfilePage()));
      expect(find.byType(ProfileView), findsOneWidget);
    });
  });

  group('ProfileView', () {
    testWidgets('navigates to ThemePage when lightMode button is tapped',
        (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.system);
      await tester.pumpApp(MultiBlocProvider(
        providers: [
          BlocProvider.value(value: profileCubit),
          BlocProvider.value(value: themeCubit),
        ],
        child: ProfileView(),
      ));
      await tester.tap(find.byKey(const Key('theme_update')));
      await tester.pumpAndSettle();
      expect(find.byType(ThemePage), findsOneWidget);
    });
  });
}
