import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/on_boarding/start.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/brand.dart';
import 'package:talao/deep_link/deep_link.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class SplashPage extends StatefulWidget {
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
  bool _isKeyLoaded = false;

  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
    Future.delayed(
      Duration(milliseconds: 50),
      () async {
        final key = await SecureStorageProvider.instance.get('key') ?? '';

        if (key.isEmpty) {
          Future.delayed(
              Duration(
                milliseconds: 800,
              ), () {
            Navigator.of(context).push<void>(OnBoardingStartPage.route());
          });

          return;
        } else {
          setState(() {
            _isKeyLoaded = true;
          });
        }
      },
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

    return BlocListener<WalletBloc, WalletBlocState>(
      listener: (context, state) {
        if (_isKeyLoaded && state is WalletBlocList) {
          Future.delayed(
              Duration(
                milliseconds: 800,
              ), () {
            Navigator.of(context).push<void>(
              CredentialsList.route(),
            );
          });
        }
      },
      child: BasePage(
        backgroundColor: UiKit.palette.background,
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
