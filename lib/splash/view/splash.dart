import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/interop/check_issuer/check_issuer.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/scan/bloc/scan.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';
import 'package:talao/drawer/profile/cubit/profile_state.dart';
import 'package:talao/onboarding/key/view/onboarding_key_page.dart';
import 'package:talao/qr_code/qr_code.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/deep_link/deep_link.dart';
import 'package:talao/onboarding/onboarding.dart';
import 'package:talao/theme/theme.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_player/video_player.dart';

bool _initialUriIsHandled = false;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

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
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller =
        VideoPlayerController.asset('assets/splash/talao_animation_logo.mp4');
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.play();
    _controller!.setLooping(true);
    Future.delayed(
      Duration(seconds: 0),
      () async {
        await context.read<ThemeCubit>().getCurrentTheme();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller?.dispose();
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
            Navigator.of(context).push(CredentialsList.route());
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

  Future<bool?> checkHost(
      Uri uri, Issuer approvedIssuer, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: localizations.scanPromptHost,
          subtitle: (approvedIssuer.did.isEmpty)
              ? uri.host
              : '${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}',
          yes: localizations.communicationHostAllow,
          no: localizations.communicationHostDeny,
          lock: (uri.scheme == 'http') ? true : false,
        );
      },
    );
  }

  Future<Issuer> isApprovedIssuer(Uri uri, BuildContext context) async {
    final client = DioClient(Constants.checkIssuerServerUrl, Dio());
    final profileCubit = context.read<ProfileCubit>();
    final profile = profileCubit.state;
    if (profile is ProfileStateDefault) {
      final isIssuerVerificationSettingTrue =
          profile.model!.issuerVerificationSetting;
      if (isIssuerVerificationSettingTrue) {
        try {
          return await CheckIssuer(client, Constants.checkIssuerServerUrl, uri)
              .isIssuerInApprovedList();
        } catch (e) {
          if (e is ErrorHandler) {
            e.displayError(context, e, Theme.of(context).colorScheme.error);
          }
          return Issuer.emptyIssuer();
        }
      }
    }
    await profileCubit.close();
    return Issuer.emptyIssuer();
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
            if (state.status == KeyStatus.needsKey) {
              Future.delayed(
                Duration(seconds: 5),
                () => Navigator.of(context).push(OnBoardingStartPage.route()),
              );
            }
            if (state.status == KeyStatus.hasKey) {
              Future.delayed(
                Duration(seconds: 5),
                () => Navigator.of(context).push(CredentialsList.route()),
              );
            }
            if (state.status == KeyStatus.resetKey) {
              Navigator.of(context).pushReplacement(OnBoardingKeyPage.route());
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
            if (state is QRCodeStateMessage) {
              final errorHandler = state.message.errorHandler;
              if (errorHandler != null) {
                final color =
                    state.message.color ?? Theme.of(context).colorScheme.error;
                errorHandler.displayError(context, errorHandler, color);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: state.message.color,
                  content: Text(state.message.message!),
                ));
              }
            }
          },
        ),
        BlocListener<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanStateMessage) {
              final errorHandler = state.message.errorHandler;
              if (errorHandler != null) {
                final color =
                    state.message.color ?? Theme.of(context).colorScheme.error;
                errorHandler.displayError(context, errorHandler, color);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: state.message.color,
                  content: Text(state.message.message!),
                ));
              }
            }
          },
        ),
      ],
      child: BasePage(
        backgroundColor: const Color(0xffffffff),
        scrollView: false,
        body: Center(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
