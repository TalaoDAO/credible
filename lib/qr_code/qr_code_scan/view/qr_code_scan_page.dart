import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) async {
        if (state is QRCodeScanStateSuccess) {
          await qrController.stopCamera();
        }
        if (state is QRCodeScanStateMessage) {
          await qrController.resumeCamera();
          isQrCodeScanned = false;
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
