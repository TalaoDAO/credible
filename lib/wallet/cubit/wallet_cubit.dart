import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:bloc/bloc.dart';

part 'wallet_state.dart';

part 'wallet_cubit.g.dart';

class WalletCubit extends Cubit<WalletState> {
  final CredentialsRepository repository;

  WalletCubit(this.repository) : super(WalletState()) {
    checkKey();
  }

  Future checkKey() async {
    final key = await SecureStorageProvider.instance.get('key');
    if (key == null) {
      emit(state.copyWith(status: KeyStatus.needsKey));
    } else {
      if (key.isEmpty) {
        emit(state.copyWith(status: KeyStatus.needsKey));
      } else {
        /// When app is initialized, set all credentials with active status to unknown status
        await repository.initializeRevocationStatus();
        emit(state.copyWith(status: KeyStatus.hasKey));

        /// load all credentials from repository
        await emitData();
      }
    }
  }

  Future deleteById(String id) async {
    await repository.deleteById(id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == id);
    emit(state.copyWith(credentials: credentials));
  }

  Future updateCredential(CredentialModel credential) async {
    await repository.update(credential);
    // final credentials = state.credentials;
    // final index = credentials
    //     .indexWhere((element) => element.id == credential.id.toString());
    // credentials[index] = credential;
    //
    // emit(state.copyWith(credentials: credentials));
    await emitData();
  }

  Future insertCredential(CredentialModel credential) async {
    await repository.insert(credential);
    await emitData();
  }

  Future resetWallet() async {
    await repository.deleteAll();
    emit(state.copyWith(status: KeyStatus.resetKey, credentials: []));
  }

  Future emitData(/* dynamic filters */) async {
    await repository.findAll(/* filters */).then((values) {
      emit(state.copyWith(credentials: values));
    });
  }
}
