import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/qr_code/bloc/qrcode.dart';
import 'package:talao/app/pages/qr_code/check_host.dart';
import 'package:talao/app/pages/qr_code/is_issuer_approved.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/brand.dart';
import 'package:talao/deep_link/deep_link.dart';
import 'package:talao/onboarding/onboarding.dart';
import 'package:talao/theme/theme.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (context) => SplashPage(),
        settings: RouteSettings(name: '/splash'));
  }

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 0),
      () async {
        await context.read<ThemeCubit>().getCurrentTheme();
      },
    );
    Future.delayed(
      Duration(milliseconds: 1500),
      () async {},
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks(BuildContext context) {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        uri?.queryParameters.forEach((key, value) {
          if (key == 'uri') {
            final url = value.replaceAll(RegExp(r'^\"|\"$'), '');
            context.read<DeepLinkCubit>().addDeepLink(url);
            Navigator.of(context).pushAndRemoveUntil(
                CredentialsList.route(), ModalRoute.withName('/splash'));
          }
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri(BuildContext context) async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          if (!mounted) return;
          print('got uri: $uri');
          uri.queryParameters.forEach((key, value) {
            if (key == 'uri') {
              /// add uri to deepLink cubit
              final url = value.replaceAll(RegExp(r'^\"|\"$'), '');
              context.read<DeepLinkCubit>().addDeepLink(url);
            }
          });
        }
        if (!mounted) return;
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleIncomingLinks(context);
    _handleInitialUri(context);
    final localizations = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state.status == KeyStatus.unAuthenticated) {
              //todo check onboarding key or sth if we skip onboarding next time
              Navigator.of(context)
                  .pushReplacement(OnBoardingStartPage.route());
            }
            if (state.status == KeyStatus.authenticated) {
              Navigator.of(context).push<void>(CredentialsList.route());
            }
          },
        ),
        BlocListener<QRCodeBloc, QRCodeState>(
          listener: (context, state) async {
            if (state is QRCodeStateHost) {
              var approvedIssuer = await isApprovedIssuer(state.uri, context);
              var acceptHost;
              acceptHost =
                  await checkHost(state.uri, approvedIssuer, context) ?? false;

              if (acceptHost) {
                context.read<QRCodeBloc>().add(QRCodeEventAccept(state.uri));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(localizations.scanRefuseHost),
                ));
                await Navigator.of(context)
                    .pushReplacement(CredentialsList.route());
              }
            }
            if (state is QRCodeStateSuccess) {
              await Navigator.of(context).pushReplacement(state.route);
            }
          },
        ),
        BlocListener<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanStateMessage) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: state.message.color,
                content: Text(state.message.message!),
              ));
            }
          },
        ),
      ],
      child: BasePage(
        backgroundColor: const Color(0xff121212),
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24.0),
          child: BrandMinimal(),
        ),
      ),
    );
  }
}
