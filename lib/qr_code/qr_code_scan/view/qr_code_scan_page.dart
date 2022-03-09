import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_scan_state.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'package:talao/scan/bloc/scan.dart';

class QrCodeScanPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => BlocProvider<QRCodeScanCubit>(
          create: (context) => QRCodeScanCubit(
            client: DioClient(Constants.checkIssuerServerUrl, Dio()),
            scanBloc: context.read<ScanBloc>(),
            queryByExampleCubit: context.read<QueryByExampleCubit>(),
            profileCubit: context.read<ProfileCubit>(),
          ),
          child: QrCodeScanPage(),
        ),
        settings: RouteSettings(name: '/qrCodeScanPage'),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;

  bool promptActive = false;

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
      if (scanData.code is String && !promptActive) {
        setState(() {
          promptActive = true;
        });
        context.read<QRCodeScanCubit>().host(scanData.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) async {
        print(
            '####################################################################################################################################################################################');
        print('QRCodePage - QR $state');
        print(
            '####################################################################################################################################################################################');
        if (state is QRCodeScanStateHost) {
          var approvedIssuer = await context
              .read<QRCodeScanCubit>()
              .isApprovedIssuer(state.uri!, context);

          var acceptHost = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialog(
                    title: localizations.scanPromptHost,
                    subtitle: (approvedIssuer.did.isEmpty)
                        ? state.uri!.host
                        : '${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}',
                    yes: localizations.communicationHostAllow,
                    no: localizations.communicationHostDeny,
                    lock: (state.uri!.scheme == 'http') ? true : false,
                  );
                },
              ) ??
              false;

          if (acceptHost) {
            context.read<QRCodeScanCubit>().accept(state.uri!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(localizations.scanRefuseHost),
            ));
            await Navigator.of(context)
                .pushReplacement(CredentialsList.route());
          }
        }
        if (state is QRCodeScanStateSuccess) {
          await Navigator.of(context).pushReplacement(state.route!);
        }
        if (state is QRCodeScanStateMessage) {
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
          await qrController.resumeCamera();
          await qrController.resumeCamera();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(localizations.scanUnsupportedMessage),
          ));
        }
      },
      child: BasePage(
        padding: EdgeInsets.zero,
        title: localizations.scanTitle,
        scrollView: false,
        extendBelow: true,
        titleLeading: BackLeadingButton(),
        body: SafeArea(
          child: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white70,
            ),
            onQRViewCreated: onQRViewCreated,
          ),
        ),
      ),
    );
  }
}
