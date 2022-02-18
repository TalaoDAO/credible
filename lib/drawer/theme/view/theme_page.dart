import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/drawer/theme/view/widget/theme_item.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemePage extends StatelessWidget {
  static Route route(ThemeCubit themeCubit) => MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: themeCubit,
          child: ThemePage(),
        ),
        settings: RouteSettings(name: '/themePage'),
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
                key: Key('set_light_theme'),
                isTrue: state == ThemeMode.light,
                title: localizations.lightThemeText,
                onTap: () async =>
                    await context.read<ThemeCubit>().setLightTheme(),
              ),
              ThemeItem(
                key: Key('set_dark_theme'),
                isTrue: state == ThemeMode.dark,
                title: localizations.darkThemeText,
                onTap: () async =>
                    await context.read<ThemeCubit>().setDarkTheme(),
              ),
              ThemeItem(
                key: Key('set_system_theme'),
                isTrue: state == ThemeMode.system,
                title: localizations.systemThemeText,
                onTap: () async =>
                    await context.read<ThemeCubit>().setSystemTheme(),
              ),
            ],
          ),
        );
      },
    );
  }
}
