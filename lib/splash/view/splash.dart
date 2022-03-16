import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/issuer/check_issuer.dart';
import 'package:talao/app/interop/issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code_scan/qr_code_scan.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/deep_link/deep_link.dart';
import 'package:talao/onboarding/onboarding.dart';
import 'package:talao/scan/scan.dart';
import 'package:talao/theme/theme.dart';
import 'package:talao/wallet/wallet.dart';
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
  SecureStorageProvider secureStorageProvider = SecureStorageProvider.instance;

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
        final key = await secureStorageProvider.get('key');
        if (key == null || key.isEmpty) {
          return await onBoarding();
        }

        var did = await secureStorageProvider.get(SecureStorageKeys.did);
        var didMethod =
            await secureStorageProvider.get(SecureStorageKeys.didMethod);
        var didMethodName =
            await secureStorageProvider.get(SecureStorageKeys.didMethodName);
        if (did == null || did.isEmpty) {
          return await onBoarding();
        }
        if (didMethod == null || didMethod.isEmpty) {
          return await onBoarding();
        }
        if (didMethodName == null || didMethodName.isEmpty) {
          return await onBoarding();
        }

        final isEnterprise =
            await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser);
        if (isEnterprise == null || isEnterprise.isEmpty) {
          return await onBoarding();
        }

        if (isEnterprise == 'true') {
          final rsaKeyJson =
              await secureStorageProvider.get(SecureStorageKeys.rsaKeyJson);
          if (rsaKeyJson == null || rsaKeyJson.isEmpty) {
            return await onBoarding();
          }
        }
        context
            .read<DIDCubit>()
            .load(did: did, didMethod: didMethod, didMethodName: didMethodName);
        Future.delayed(
          Duration(seconds: 5),
          () async {
            await _controller!.pause();
            return Navigator.of(context).push(CredentialsListPage.route());
          },
        );
      },
    );
    super.initState();
  }

  Future<void> onBoarding() async {
    Future.delayed(
      Duration(seconds: 5),
      () {
        _controller!.pause();
        Navigator.of(context).push(OnBoardingStartPage.route());
      },
    );
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
        uri?.queryParameters.forEach((key, value) async {
          if (key == 'uri') {
            final url = value.replaceAll(RegExp(r'ß^\"|\"$'), '');
            context.read<DeepLinkCubit>().addDeepLink(url);
            final key = await SecureStorageProvider.instance.get('key');
            if (key != null) {
              context.read<QRCodeScanCubit>().deepLink();
            }
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
    var l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state.status == WalletStatus.insert) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.credentialAddedMessage),
              ));
            }
            if (state.status == WalletStatus.update) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.credentialDetailEditSuccessMessage),
              ));
            }
            if (state.status == WalletStatus.delete) {
              final message = StateMessage(
                message: l10n.credentialDetailDeleteSuccessMessage,
                type: MessageType.success,
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: message.color,
                content: Text(message.message!),
              ));
              Navigator.of(context).pop();
            }
            if (state.status == WalletStatus.reset) {
              Navigator.of(context)
                  .pushReplacement(ChooseWalletTypePage.route());
            }
          },
        ),
        BlocListener<ScanCubit, ScanState>(
          listener: (context, state) async {
            if (state is ScanStateMessage) {
              final errorHandler = state.message!.errorHandler;
              if (errorHandler != null) {
                final color =
                    state.message!.color ?? Theme.of(context).colorScheme.error;
                errorHandler.displayError(context, errorHandler, color);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: state.message!.color,
                  content: Text(state.message!.message!),
                ));
              }
            }
            if (state is ScanStateAskPermissionDIDAuth) {
              final l10n = context.l10n;
              final scanCubit = context.read<ScanCubit>();
              final state = scanCubit.state;
              final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title:
                          '${l10n.credentialPresentTitleDIDAuth}\n${l10n.confimrDIDAuth}',
                      yes: l10n.showDialogYes,
                      no: l10n.showDialogNo,
                    ),
                  ) ??
                  false;

              if (confirm && state is ScanStateAskPermissionDIDAuth) {
                scanCubit.getDIDAuthCHAPI(
                    keyId: state.keyId!,
                    done: state.done!,
                    uri: state.uri!,
                    challenge: state.challenge!,
                    domain: state.domain!);
              } else {
                Navigator.of(context).pop();
              }
            }
            if (state is ScanStateSuccess) {
              Navigator.of(context).pop();
            }
            if (state is ScanStateIdle) {
              Navigator.of(context).pop();
            }
          },
        ),

        ///Note - Sync listener content with qr code scan listener
        BlocListener<QRCodeScanCubit, QRCodeScanState>(
            listener: (context, state) async {
          if (state.isDeepLink == null) return;
          if (!state.isDeepLink!) return;

          if (state is QRCodeScanStateHost) {
            // if (state.promptActive!) return;
            // context.read<QRCodeScanCubit>().promptDeactivate();
            var approvedIssuer = Issuer.emptyIssuer();

            var profileCubit = context.read<ProfileCubit>();
            if (profileCubit.state is ProfileStateDefault) {
              final isIssuerVerificationSettingTrue =
                  profileCubit.state.model!.issuerVerificationSetting;
              if (isIssuerVerificationSettingTrue) {
                try {
                  approvedIssuer = await CheckIssuer(
                          DioClient(Constants.checkIssuerServerUrl, Dio()),
                          Constants.checkIssuerServerUrl,
                          state.uri!)
                      .isIssuerInApprovedList();
                } catch (e) {
                  if (e is ErrorHandler) {
                    e.displayError(
                        context, e, Theme.of(context).colorScheme.error);
                  }
                }
              }
            }
            var acceptHost = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      title: l10n.scanPromptHost,
                      subtitle: (approvedIssuer.did.isEmpty)
                          ? state.uri!.host
                          : '${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}',
                      yes: l10n.communicationHostAllow,
                      no: l10n.communicationHostDeny,
                      lock: (state.uri!.scheme == 'http') ? true : false,
                    );
                  },
                ) ??
                false;

            if (acceptHost) {
              context.read<QRCodeScanCubit>().accept(state.uri!, true);
            } else {
              //await qrController.resumeCamera();
              context.read<QRCodeScanCubit>().emitWorkingState();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.scanRefuseHost),
              ));
            }
          }
          if (state is QRCodeScanStateSuccess) {
            //   await qrController.stopCamera();
            ///Note: Push
            await Navigator.of(context).push(state.route!);
          }
          if (state is QRCodeScanStateMessage) {
            //   await qrController.resumeCamera();
            final errorHandler = state.message!.errorHandler;
            if (errorHandler != null) {
              final color =
                  state.message!.color ?? Theme.of(context).colorScheme.error;
              errorHandler.displayError(context, errorHandler, color);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: state.message!.color,
                content: Text(state.message!.message!),
              ));
            }
          }
          if (state is QRCodeScanStateUnknown) {
            //   await qrController.resumeCamera();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.scanUnsupportedMessage),
            ));
          }
        })
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
