import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/did/did.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:talao/scan/cubit/scan_cubit.dart';
import 'package:talao/app/router_observer.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'package:talao/splash/splash.dart';
import 'package:talao/theme/theme.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

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
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
              secureStorageProvider: SecureStorageProvider.instance),
        ),
        BlocProvider<WalletCubit>(
          lazy: false,
          create: (context) => WalletCubit(
              repository: CredentialsRepository(SecureStorageProvider.instance),
              secureStorageProvider: SecureStorageProvider.instance,
              profileCubit: context.read<ProfileCubit>()),
        ),
        BlocProvider<ScanCubit>(
          create: (context) => ScanCubit(
            client: DioClient(Constants.checkIssuerServerUrl, Dio()),
            walletCubit: context.read<WalletCubit>(),
            didKitProvider: DIDKitProvider.instance,
            secureStorageProvider: SecureStorageProvider.instance,
          ),
        ),
        BlocProvider<QRCodeScanCubit>(
          create: (context) => QRCodeScanCubit(
              client: DioClient(Constants.checkIssuerServerUrl, Dio()),
              scanCubit: context.read<ScanCubit>(),
              queryByExampleCubit: context.read<QueryByExampleCubit>(),
              deepLinkCubit: context.read<DeepLinkCubit>()),
        ),
        BlocProvider<DIDCubit>(
          create: (context) => DIDCubit(
            secureStorageProvider: SecureStorageProvider.instance,
            didKitProvider: DIDKitProvider.instance,
          ),
          child: GlobalInformationPage(),
        )
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
