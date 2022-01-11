import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:talao/app/pages/profile/usecase/is_issuer_approved.dart'
    as issuer_approved_usecase;
import 'package:talao/app/pages/qr_code/bloc/qrcode.dart';
import 'package:talao/app/pages/qr_code/check_host.dart';
import 'package:talao/app/shared/error_handler/error_hadler.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';

class QrCodeScanPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => QrCodeScanPage(),
      );

  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;

  late bool flash;
  bool promptActive = false;

  @override
  void initState() {
    super.initState();
    flash = false;
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

    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if (scanData.code is String) {
        context.read<QRCodeBloc>().add(QRCodeEventHost(scanData.code));
      }
    });
  }

  void promptHost(Uri uri) async {
    // TODO [bug] find out why the camera sometimes sends a code twice
    if (!promptActive) {
      setState(() {
        promptActive = true;
      });

      final localizations = AppLocalizations.of(context)!;
      var approvedIssuer =
          await issuer_approved_usecase.ApprovedIssuer(uri, context);
      var acceptHost;
      acceptHost = await checkHost(uri, approvedIssuer, context) ?? false;

      if (acceptHost) {
        context.read<QRCodeBloc>().add(QRCodeEventAccept(uri));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(localizations.scanRefuseHost),
        ));
      }

      setState(() {
        promptActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocListener<QRCodeBloc, QRCodeState>(
      listener: (context, state) {
        if (state is QRCodeStateMessage) {
          qrController.resumeCamera();
          if (state.message.errorHandler != null) {
            var error = state.message.errorHandler;
            if (error is ErrorHandler) {
              ErrorHandler.displayError(context, error, Colors.red);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: state.message.color,
              content: Text(state.message.message),
            ));
          }
        }
        if (state is QRCodeStateHost) {
          promptHost(state.uri);
        }
        if (state is QRCodeStateUnknown) {
          qrController.resumeCamera();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(localizations.scanUnsupportedMessage),
          ));
        }
        if (state is QRCodeStateSuccess) {
          Navigator.of(context).pushReplacement(state.route);
        }
      },
      child: BasePage(
        padding: EdgeInsets.zero,
        title: localizations.scanTitle,
        scrollView: false,
        navigation: CustomNavBar(index: 1),
        extendBelow: true,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.white70,
                ),
                onQRViewCreated: onQRViewCreated,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
