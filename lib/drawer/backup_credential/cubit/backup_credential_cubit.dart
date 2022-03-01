import 'dart:convert';
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/interop/local_notification/local_notification.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/encryption.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';
import 'package:path/path.dart' as path;

part 'backup_credential_state.dart';

part 'backup_credential_cubit.g.dart';

class BackupCredentialCubit extends Cubit<BackupCredentialState> {
  final SecureStorageProvider secureStorageProvider;
  final CryptoKeys cryptoKeys;
  final WalletCubit walletCubit;
  final LocalNotification localNotification;

  BackupCredentialCubit({
    required this.secureStorageProvider,
    required this.cryptoKeys,
    required this.walletCubit,
    required this.localNotification,
  }) : super(BackupCredentialState());

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

  Future<void> encryptAndDownloadFile() async {
    emit(state.copyWith(status: BackupCredentialStatus.loading));
    final downloadDirectory = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _getStoragePermission();

    if (isPermissionStatusGranted) {
      try {
        final savePath = path.join(downloadDirectory!.path);
        var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final filePath = '$savePath/talao-credential-$date.txt';
        final _myFile = File(filePath);
        var message = {
          'date': date,
          'credentials': walletCubit.state.credentials,
        };
        final mnemonicFormatted = state.mnemonic.join(' ');
        var encrypted =
            await cryptoKeys.encrypt(jsonEncode(message), mnemonicFormatted);
        await _myFile.writeAsString(jsonEncode(encrypted));
        emit(state.copyWith(
            status: BackupCredentialStatus.success, filePath: filePath));
      } catch (e) {
        emit(state.copyWith(status: BackupCredentialStatus.failure));
      }
    } else {
      emit(state.copyWith(status: BackupCredentialStatus.permissionDenied));
    }
  }
}
