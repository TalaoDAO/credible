import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/pages/profile/widgets/menu_item.dart';
import 'package:talao/app/pages/profile/widgets/theme_item.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';

class ThemePage extends StatelessWidget {
  static Route route(ThemeCubit themeCubit) => MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: themeCubit,
          child: ThemePage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    //final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {

        return BasePage(
          title: 'Select Theme',
          titleLeading: BackLeadingButton(),
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ThemeItem(
                isTrue: state.isLightTheme,
                title: 'Light Theme',
                onTap: () => context.read<ThemeCubit>().setLightTheme(),
              ),
              ThemeItem(
                isTrue: state.isDarkTheme,
                title: 'Dark Theme',
                onTap: () => context.read<ThemeCubit>().setDarkTheme(),
              ),
              ThemeItem(
                isTrue: state.isSystemTheme,
                title: 'System Theme',
                onTap: () => context.read<ThemeCubit>().setSystemTheme(),
              ),
            ],
          ),
        );
      },
    );
  }
}
