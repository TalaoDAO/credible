import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:talao/app/router_observer.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/key_generation.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/onboarding/gen_phrase/cubit/onboarding_gen_phrase_cubit.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'package:talao/theme/theme.dart';
import 'package:talao/wallet/bloc/wallet_bloc.dart';
import 'pages/qr_code/bloc/qrcode.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(SecureStorageProvider.instance)),
        BlocProvider<OnBoardingGenPhraseCubit>(
            create: (context) => OnBoardingGenPhraseCubit(
                secureStorageProvider: SecureStorageProvider.instance,
                keyGeneration: KeyGeneration())),
        BlocProvider<DeepLinkCubit>(create: (context) => DeepLinkCubit()),
        BlocProvider<QueryByExampleCubit>(
            create: (context) => QueryByExampleCubit()),
        BlocProvider<WalletBloc>(
            lazy: false,
            create: (context) => WalletBloc(
                CredentialsRepository(SecureStorageProvider.instance))
              ..checkKey()),
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
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
              secureStorageProvider: SecureStorageProvider.instance),
        ),
        BlocProvider<DIDBloc>(
          create: (context) => DIDBloc(
            secureStorageProvider: SecureStorageProvider.instance,
            didKitProvider: DIDKitProvider.instance,
          ),
        ),
      ],
      child: MaterialAppDefinition(),
    );
  }
}

class MaterialAppDefinition extends StatelessWidget {
  const MaterialAppDefinition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talao-Wallet',
      home: SplashPage(),
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      navigatorObservers: [MyRouteObserver()],
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
