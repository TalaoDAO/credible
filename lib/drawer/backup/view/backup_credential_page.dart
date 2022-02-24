import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/local_notification/local_notification.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:path/path.dart' as path;

class BackupCredentialPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => BackupCredentialPage(),
        settings: RouteSettings(name: '/backupCredentialPage'),
      );

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      //todo: show dialog to choose this option
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.backupCredential,
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseButton.primary(
            context: context,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () async {
              //todo: if credential is empty show popup
              final downloadDirectory = await _getDownloadDirectory();
              final isPermissionStatusGranted = await _getStoragePermission();

              if (isPermissionStatusGranted) {
                final savePath = path.join(downloadDirectory!.path);
                final filePath = '$savePath/credential.txt';
                final _myFile = File(filePath);
                await _myFile.writeAsString('My name is Bibash');
                await LocalNotification().showNotification(filePath);
              } else {
                // show snackbar after user declines
              }
            },
            child: Text('Backup'),
          )
        ],
      ),
    );
  }
}
