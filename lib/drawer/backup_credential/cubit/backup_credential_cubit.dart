import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:permission_handler/permission_handler.dart';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/interop/local_notification/local_notification.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

part 'backup_credential_state.dart';

part 'backup_credential_cubit.g.dart';

class BackupCredentialCubit extends Cubit<BackupCredentialState> {
  final SecureStorageProvider secureStorageProvider;
  final CryptoKeys cryptoKeys;
  final WalletCubit walletCubit;
  final LocalNotification localNotification;
  final FileSaver fileSaver;

  BackupCredentialCubit({
    required this.secureStorageProvider,
    required this.cryptoKeys,
    required this.walletCubit,
    required this.localNotification,
    required this.fileSaver,
  }) : super(BackupCredentialState());

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
    final isPermissionStatusGranted = await _getStoragePermission();

    if (isPermissionStatusGranted) {
      try {
        var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        var fileName = getFileName(date);
        var message = {
          'date': date,
          'credentials': walletCubit.state.credentials,
        };
        final mnemonicFormatted = state.mnemonic.join(' ');
        print(mnemonicFormatted);
        var encrypted =
            await cryptoKeys.encrypt(jsonEncode(message), mnemonicFormatted);
        var filePath = await fileSaver.saveAs(
            fileName,
            Uint8List.fromList(jsonEncode(encrypted).runes.toList()),
            'txt',
            MimeType.TEXT);
        print('*********************************************************');
        print(filePath);
        print('*********************************************************');
        emit(state.copyWith(
            status: BackupCredentialStatus.success, filePath: filePath));
      } catch (e) {
        print(e.toString());
        print('*********************************************************');
        print(e.toString());
        print('*********************************************************');
        emit(state.copyWith(status: BackupCredentialStatus.failure));
      }
    } else {
      emit(state.copyWith(status: BackupCredentialStatus.permissionDenied));
    }
  }

  String getFileName(String date) {
    var millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    var fileName = 'talao-credential-$date-$millisecondsSinceEpoch';
    return fileName;
  }
}
