import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/interop/local_notification/local_notification.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/mnemonic.dart';
import 'package:talao/drawer/backup_credential/backup_credential.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

class BackupCredentialPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => BackupCredentialCubit(
            secureStorageProvider: SecureStorageProvider.instance,
            cryptoKeys: CryptoKeys(),
            walletCubit: context.read<WalletCubit>(),
            localNotification: LocalNotification(),
            fileSaver: FileSaver.instance
          ),
          child: BackupCredentialPage(),
        ),
        settings: RouteSettings(name: '/backupCredentialPage'),
      );

  @override
  State<BackupCredentialPage> createState() => _BackupCredentialPageState();
}

class _BackupCredentialPageState extends State<BackupCredentialPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.backupCredential,
      titleLeading: BackLeadingButton(),
      body: BlocConsumer<BackupCredentialCubit, BackupCredentialState>(
        listener: (context, state) async {
          if (state.status == BackupCredentialStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.backupCredentialError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ));
          }
          if (state.status == BackupCredentialStatus.permissionDenied) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.backupCredentialPermissionDeniedMessage),
            ));
          }
          if (state.status == BackupCredentialStatus.success) {
            await context
                .read<BackupCredentialCubit>()
                .localNotification
                .showNotification(
                  filePath: state.filePath,
                  title: l10n.backupCredentialNotificationTitle,
                  message: l10n.backupCredentialNotificationMessage,
                );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.backupCredentialSuccessMessage),
            ));
          }
        },
        builder: (context, state) {
          return Column(
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
              MnemonicDisplay(mnemonic: state.mnemonic),
              const SizedBox(height: 32.0),
              Container(
                height: 42,
                child: BaseButton.primary(
                  context: context,
                  onPressed: state.status == BackupCredentialStatus.loading
                      ? null
                      : () async {
                          await context
                              .read<BackupCredentialCubit>()
                              .encryptAndDownloadFile();
                        },
                  child: Text(l10n.backupCredentialButtonTitle),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
