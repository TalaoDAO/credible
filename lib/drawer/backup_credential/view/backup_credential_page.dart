import 'dart:convert';
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/local_notification/local_notification.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/mnemonic.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:path/path.dart' as path;
import 'package:talao/wallet/cubit/wallet_cubit.dart';
import 'package:bip39/bip39.dart' as bip39;

class BackupCredentialPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => BackupCredentialPage(),
        settings: RouteSettings(name: '/backupCredentialPage'),
      );

  @override
  State<BackupCredentialPage> createState() => _BackupCredentialPageState();
}

class _BackupCredentialPageState extends State<BackupCredentialPage> {
  List<String>? _mnemonic;

  @override
  void initState() {
    super.initState();
    setState(() {
      _mnemonic = bip39.generateMnemonic().split(' ');
    });
  }

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
          Column(
            children: [
              Text(
                l10n.backupCredentialPhrase,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 8.0),
              Text(
                l10n.backupCredentialPhraseExplanation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          if (_mnemonic != null && _mnemonic!.isNotEmpty)
            MnemonicDisplay(mnemonic: _mnemonic!),
          const SizedBox(height: 32.0),
          BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
            return BaseButton.primary(
              context: context,
              textColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () async {
                if (state.credentials.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l10n.backupCredentialEmptyError),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                  return;
                }

                final downloadDirectory = await _getDownloadDirectory();
                final isPermissionStatusGranted = await _getStoragePermission();

                if (isPermissionStatusGranted) {
                  final savePath = path.join(downloadDirectory!.path);
                  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final filePath = '$savePath/talao-credential-$date.txt';
                  final _myFile = File(filePath);
                  var data = {
                    'date': date,
                    'credentials': state.credentials,
                  };
                  //todo: encrypt data
                  await _myFile.writeAsString(jsonEncode(data));
                  await LocalNotification().showNotification(
                    filePath: filePath,
                    title: l10n.backupCredentialNotificationTitle,
                    message: l10n.backupCredentialNotificationMessage,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l10n.backupCredentialPermissionDeniedMessage),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                }
              },
              child: Text(l10n.backupCredentialButtonTitle),
            );
          })
        ],
      ),
    );
  }
}
