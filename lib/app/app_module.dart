import 'dart:io';

import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/module.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:talao/app/pages/error/pages/error_page.dart';
import 'package:talao/app/pages/on_boarding/module.dart';
import 'package:talao/app/pages/profile/module.dart';
import 'package:talao/app/pages/qr_code/display.dart';
import 'package:talao/app/pages/qr_code/scan.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => WalletBloc(i.get())),
        Bind((i) => CredentialsRepository()),
        Bind((i) {
          // TODO: Remove this after testing is done
          // This allows self-signed certificates on the servers.
          final dio = Dio();
          if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
            (dio.httpClientAdapter as DefaultHttpClientAdapter)
                .onHttpClientCreate = (HttpClient client) {
              client.badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true;
              return client;
            };
          }
          return dio;
        }),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/splash',
          child: (context, args) => SplashPage(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/on-boarding',
          module: OnBoardingModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/credentials',
          module: CredentialsModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/profile',
          module: ProfileModule(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/qr-code/scan',
          child: (context, args) => QrCodeScanPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/qr-code/display',
          child: (context, args) => QrCodeDisplayPage(
            name: args.data[0],
            data: args.data[1],
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/error',
          child: (context, args) => ErrorPage(errorMessage: args.data),
          transition: TransitionType.fadeIn,
        ),
      ];
}
