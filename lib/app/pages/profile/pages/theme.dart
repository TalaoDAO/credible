import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/pages/profile/widgets/theme_item.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemePage extends StatelessWidget {
  static Route route(ThemeCubit themeCubit) => MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: themeCubit,
          child: ThemePage(),
        ),settings: RouteSettings(name: '/theme'),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {

        return BasePage(
          title: localizations.selectThemeText,
          titleLeading: BackLeadingButton(),
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ThemeItem(
                isTrue: state.isLightTheme,
                title: localizations.lightThemeText,
                onTap: () => context.read<ThemeCubit>().setLightTheme(),
              ),
              ThemeItem(
                isTrue: state.isDarkTheme,
                title: localizations.darkThemeText,
                onTap: () => context.read<ThemeCubit>().setDarkTheme(),
              ),
              ThemeItem(
                isTrue: state.isSystemTheme,
                title: localizations.systemThemeText,
                onTap: () => context.read<ThemeCubit>().setSystemTheme(),
              ),
            ],
          ),
        );
      },
    );
  }
}
