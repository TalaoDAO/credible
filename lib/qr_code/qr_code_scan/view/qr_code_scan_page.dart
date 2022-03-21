import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:talao/app/interop/issuer/check_issuer.dart';
import 'package:talao/app/interop/issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

class QrCodeScanPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => QrCodeScanPage(),
        settings: RouteSettings(name: '/qrCodeScanPage'),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;

  final isDeepLink = false;
  bool isQrCodeScanned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    qrController.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController.pauseCamera();
    } else if (Platform.isIOS) {
      qrController.resumeCamera();
    }
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController.scannedDataStream.listen((scanData) {
      qrController.pauseCamera();
      if (scanData.code is String && !isQrCodeScanned) {
        isQrCodeScanned = true;
        context
            .read<QRCodeScanCubit>()
            .host(url: scanData.code, isDeepLink: isDeepLink);
      }
    });
  }

  Future<void> resumeCamera() async {
    await qrController.resumeCamera();
    isQrCodeScanned = false;
    context.read<QRCodeScanCubit>().emitWorkingState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    ///Note - Sync listener content with credential listener
    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) async {
        if (state is QRCodeScanStateHost) {
          final profileCubit = context.read<ProfileCubit>();
          final qrCodeCubit = context.read<QRCodeScanCubit>();
          final walletCubit = context.read<WalletCubit>();

          ///Check openId or https
          if (qrCodeCubit.isOpenIdUrl()) {
            ///restrict non-enterprise user
            ///TODO: Remove this comment
            // if (!profileCubit.state.model.isEnterprise) {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       content: Text(l10n.personalOpenIdRestrictionMessage)));
            //   return;
            // }

            ///credential should not be empty since we have to present
            if (walletCubit.state.credentials.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.credentialEmptyError)));
              return;
            }

            ///request attribute check
            if (qrCodeCubit.requestAttributeExists()) {
              return qrCodeCubit.emitQRCodeScanStateUnknown(
                  isDeepLink: isDeepLink);
            }

            ///request_uri attribute check
            if (!qrCodeCubit.requestUriAttributeExists()) {
              return qrCodeCubit.emitQRCodeScanStateUnknown(
                  isDeepLink: isDeepLink);
            }

            var sIOPV2Param =
                await qrCodeCubit.getSIOPV2Parameters(isDeepLink: isDeepLink);

            ///check if claims exists
            if (sIOPV2Param.claims == null) {
              return qrCodeCubit.emitQRCodeScanStateUnknown(
                  isDeepLink: isDeepLink);
            }

            var openIdCredential =
                qrCodeCubit.getCredential(sIOPV2Param.claims!);
            var openIdIssuer = qrCodeCubit.getIssuer(sIOPV2Param.claims!);

            ///check if credential and issuer both are not present
            ///TODO: Review this code... JSONPath should not cause issue in future
            if (openIdCredential == '' && openIdIssuer == '') {
              return qrCodeCubit.emitQRCodeScanStateUnknown(
                  isDeepLink: isDeepLink);
            }

            var selectedCredentials = [];
            walletCubit.state.credentials
                .forEach((CredentialModel credentialModel) {
              var credentialTypeList = credentialModel.credentialPreview.type;
              var issuer = credentialModel.credentialPreview.issuer;

              ///credential and issuer provided in claims
              if (openIdCredential != '' && openIdIssuer != '') {
                if (credentialTypeList.contains(openIdCredential) &&
                    openIdIssuer == issuer) {
                  selectedCredentials.add(credentialModel);
                }
              }

              ///credential provided in claims
              if (openIdCredential != '' &&
                  credentialTypeList.contains(openIdCredential)) {
                selectedCredentials.add(credentialModel);
              }

              ///issuer provided in claims
              if (openIdIssuer != '' && openIdIssuer == issuer) {
                selectedCredentials.add(credentialModel);
              }
            });

            qrCodeCubit.presentCredentialToSiopV2Request(
                selectedCredentials, sIOPV2Param);
          } else {
            var approvedIssuer = Issuer.emptyIssuer();
            final isIssuerVerificationSettingTrue =
                profileCubit.state.model.issuerVerificationSetting;

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
              context
                  .read<QRCodeScanCubit>()
                  .accept(uri: state.uri!, isDeepLink: isDeepLink);
            } else {
              await resumeCamera();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.scanRefuseHost),
              ));
            }
          }
        }
        if (state is QRCodeScanStateSuccess) {
          await qrController.stopCamera();

          ///Note: PushReplacement to skip qr page when pressed back from routed Screen
          await Navigator.of(context).pushReplacement(state.route!);
        }
        if (state is QRCodeScanStateMessage) {
          await resumeCamera();
          final errorHandler = state.message!.errorHandler;
          if (errorHandler != null) {
            final color =
                state.message!.color ?? Theme.of(context).colorScheme.error;
            errorHandler.displayError(context, errorHandler, color);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: state.message!.color,
              content: Text(state.message?.getMessage(context) ?? ''),
            ));
          }
        }
        if (state is QRCodeScanStateUnknown) {
          await resumeCamera();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.scanUnsupportedMessage),
          ));
        }
      },
      child: BasePage(
        padding: EdgeInsets.zero,
        title: l10n.scanTitle,
        scrollView: false,
        extendBelow: true,
        titleLeading: BackLeadingButton(),
        body: SafeArea(
          child: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(borderColor: Colors.white70),
            onQRViewCreated: onQRViewCreated,
          ),
        ),
      ),
    );
  }
}
