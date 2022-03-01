import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:path_provider/path_provider.dart';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/encryption.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

part 'recovery_credential_state.dart';

part 'recovery_credential_cubit.g.dart';

class RecoveryCredentialCubit extends Cubit<RecoveryCredentialState> {
  final WalletCubit walletCubit;

  RecoveryCredentialCubit({
    required this.walletCubit,
  }) : super(RecoveryCredentialState());

  void isMnemonicsValid(String value) {
    emit(
      state.copyWith(
          isTextFieldEdited: value.isNotEmpty,
          isMnemonicValid: bip39.validateMnemonic(value)),
    );
  }

  Future<void> recoverWallet(String text) async {
    emit(state.copyWith(status: RecoveryCredentialStatus.loading));
    var appDir = (await getTemporaryDirectory()).path;
    await Directory(appDir).delete(recursive: true);
    var result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if (result != null) {
      try {
        var file = File(result.files.single.path!);
        var text = await file.readAsString();
        Map json = jsonDecode(text);
        var encryption = Encryption(
            cipherText: json['cipherText'],
            authenticationTag: json['authenticationTag']);
        var decryptedText = await CryptoKeys().decrypt(text, encryption);
        //todo: verify data
        Map decryptedJson = jsonDecode(decryptedText);
        List credentialJson = decryptedJson['credentials'];
        var credentials = credentialJson
            .map((credential) => CredentialModel.fromJson(credential));
        await walletCubit.recoverWallet(credentials.toList());
        emit(state.copyWith(
            status: RecoveryCredentialStatus.success,
            recoveredCredentialLength: credentials.length));
      } catch (e) {
        emit(state.copyWith(status: RecoveryCredentialStatus.failure));
      }
    }
  }
}
