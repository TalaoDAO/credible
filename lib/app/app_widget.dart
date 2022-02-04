import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:talao/app/pages/profile/blocs/did.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'package:talao/theme/theme.dart';
import 'pages/credentials/blocs/wallet.dart';
import 'pages/profile/blocs/profile.dart';
import 'pages/qr_code/bloc/qrcode.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(SecureStorageProvider.instance)),
        BlocProvider<DeepLinkCubit>(create: (context) => DeepLinkCubit()),
        BlocProvider<QueryByExampleCubit>(
            create: (context) => QueryByExampleCubit()),
        BlocProvider<WalletBloc>(
            create: (context) => WalletBloc(CredentialsRepository())),
        BlocProvider<ScanBloc>(
            create: (context) => ScanBloc(
                DioClient(Constants.checkIssuerServerUrl, Dio()),
                context.read<WalletBloc>())),
        BlocProvider<QRCodeBloc>(
          create: (context) => QRCodeBloc(
            DioClient(Constants.checkIssuerServerUrl, Dio()),
            context.read<ScanBloc>(),
            context.read<QueryByExampleCubit>(),
          ),
        ),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<DIDBloc>(create: (context) => DIDBloc()),
      ],
      child: MaterialAppDefinition(),
    );
    ;
  }
}

class MaterialAppDefinition extends StatelessWidget {
  const MaterialAppDefinition({Key? key}) : super(key: key);

  ThemeData get _lightThemeData {
    final themeData = ThemeData(
      brightness: Brightness.light,
      backgroundColor: UiKit.palette.background,
      primaryColor: UiKit.palette.primary,
      // ignore: deprecated_member_use
      accentColor: UiKit.palette.accent,
      textTheme: UiKit.text.textTheme,
    );

    return themeData;
  }

  ThemeData get _darkThemeData {
    final themeData = ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Colors.red,
      primaryColor: Colors.green,
      // ignore: deprecated_member_use
      accentColor: Colors.yellow,
      textTheme: UiKit.text.textTheme,
    );

    return themeData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talao-Wallet',
      routes: {
        '/splash': (context) => SplashPage(),
      },
      initialRoute: '/splash',
      theme: _lightThemeData,
      darkTheme: _darkThemeData,
      themeMode: context.select((ThemeCubit cubit) => cubit.state),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
