import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/pages/profile/pages/theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:talao/profile/profile.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';

import '../../../helper/pump_app.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  late ProfileBloc profileBloc;
  late ThemeCubit themeCubit;

  setUp(() {
    profileBloc = MockProfileBloc();
    when(() => profileBloc.state).thenReturn(
      ProfileStateDefault(ProfileModel()),
    );
    themeCubit = MockThemeCubit();
  });

  group('ProfilePage', () {
    testWidgets('renders ProfileView', (tester) async {
      await tester.pumpApp(
          BlocProvider.value(value: profileBloc, child: ProfilePage()));
      expect(find.byType(ProfileView), findsOneWidget);
    });
  });

  group('ProfileView', () {
    testWidgets('navigates to ThemePage when lightMode button is tapped',
        (tester) async {
      when(() => themeCubit.state).thenReturn(ThemeMode.system);
      await tester.pumpApp(MultiBlocProvider(
        providers: [
          BlocProvider.value(value: profileBloc),
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
