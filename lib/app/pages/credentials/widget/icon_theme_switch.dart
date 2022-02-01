import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/theme/theme.dart';

class IconThemeSwitch extends StatelessWidget {
  const IconThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.select((ThemeCubit cubit) => cubit.state) == ThemeMode.light) {
      return IconButton(
        icon: const Icon(Icons.dark_mode),
        onPressed: () => context.read<ThemeCubit>().setDartTheme(),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.light_mode),
        onPressed: () => context.read<ThemeCubit>().setLightTheme(),
      );
    }
  }
}
