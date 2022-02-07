import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:talao/app/pages/profile/blocs/did.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:talao/app/shared/constants.dart';
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

  ThemeData get _darkThemeData => ThemeData(
        backgroundColor: const Color(0xff121212),
        primaryColor: const Color(0xffefb7ff),
        // ignore: deprecated_member_use
        accentColor: const Color(0xffbe9eff),
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xffefb7ff),
          primaryVariant: const Color(0xffbe9eff),
          secondary: const Color(0xff66fff9),
          secondaryVariant: const Color(0xff66fff9),
          surface: const Color(0xff121212),
          background: const Color(0xff121212),
          error: const Color(0xff9b374d),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.black,
        ),
        shadowColor: Colors.grey,
        textTheme: TextTheme(
          subtitle1: GoogleFonts.poppins(
            color: const Color(0xffefb7ff),
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.poppins(
            color: const Color(0xffefb7ff),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.montserrat(
            color: const Color(0xffefb7ff),
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.montserrat(
            color: const Color(0xffefb7ff),
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.poppins(
            color: const Color(0xffefb7ff),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.montserrat(
            color: const Color(0xffefb7ff),
            fontSize: 10.0,
            letterSpacing: 0.0,
          ),
          caption: GoogleFonts.montserrat(
            color: const Color(0xffefb7ff),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: const Color(0xff66fff9)),
      );

  ThemeData get _lightThemeData => ThemeData(
        backgroundColor: Colors.white,
        primaryColor: const Color(0xff6200ee),
        // ignore: deprecated_member_use
        accentColor: const Color(0xff3700b3),
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xff6200ee),
          primaryVariant: const Color(0xff3700b3),
          secondary: const Color(0xff03dac6),
          secondaryVariant: const Color(0xff018786),
          surface: Colors.white,
          background: Colors.white,
          error: const Color(0xffb00020),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
        ),
        shadowColor: Colors.grey,
        textTheme: TextTheme(
          subtitle1: GoogleFonts.poppins(
            color: const Color(0xff6200ee),
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.poppins(
            color: const Color(0xff6200ee),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.montserrat(
            color: const Color(0xff6200ee),
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.montserrat(
            color: const Color(0xff6200ee),
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.poppins(
            color: const Color(0xff6200ee),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.montserrat(
            color: const Color(0xff6200ee),
            fontSize: 10.0,
            letterSpacing: 0.0,
          ),
          caption: GoogleFonts.montserrat(
            color: const Color(0xff6200ee),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: const Color(0xff03dac6)),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talao-Wallet',
      routes: {
        '/splash': (context) =>
            SplashPage(secureStorageProvider: SecureStorageProvider.instance),
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

extension CustomColorScheme on ColorScheme {
  Color get success => brightness == Brightness.light ? const Color(0xFF28a745) : const Color(0x2228a745);
}
