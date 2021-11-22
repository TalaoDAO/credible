import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class AppWidget extends StatefulWidget {
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
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
            Modular.to.pushReplacementNamed('/credentials/list');
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

  ThemeData get _themeData {
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

  @override
  Widget build(BuildContext context) {
    _handleIncomingLinks(context);
    _handleInitialUri(context);

    return MaterialApp(
      title: 'Credible',
      initialRoute: '/splash',
      theme: _themeData,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('pt', 'BR'),
        Locale('fr', ''),
        Locale('es', ''),
        Locale('it', ''),
        Locale('de', ''),
      ],
    ).modular();
  }
}
