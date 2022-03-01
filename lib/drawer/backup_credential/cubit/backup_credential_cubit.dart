import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

part 'backup_credential_state.dart';

part 'backup_credential_cubit.g.dart';

class BackupCredentialCubit extends Cubit<BackupCredentialState> {
  final SecureStorageProvider secureStorageProvider;
  final CryptoKeys cryptoKeys;
  final WalletCubit walletCubit;

  BackupCredentialCubit({
    required this.secureStorageProvider,
    required this.cryptoKeys,
    required this.walletCubit,
  }) : super(BackupCredentialState());
}
