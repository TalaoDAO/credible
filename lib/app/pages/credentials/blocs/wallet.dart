import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:bloc/bloc.dart';

abstract class WalletBlocState {
  final List<CredentialModel> credentials = [];
}

class WalletBlocInit extends WalletBlocState {}

class WalletBlocCreateKey extends WalletBlocState {}

class WalletBlocList extends WalletBlocState {
  @override
  final List<CredentialModel> credentials;
  WalletBlocList({required this.credentials});
}

class WalletBlocListReady extends WalletBlocState {
  @override
  final List<CredentialModel> credentials;
  WalletBlocListReady({required this.credentials});
}

class WalletBloc extends Cubit<WalletBlocState> {
  final CredentialsRepository repository;

  WalletBloc(this.repository) : super(WalletBlocInit());

  void readyWalletBlocList() {
    emit(WalletBlocList(credentials: []));
  }

  Future findAll(/* dynamic filters */) async {
    await repository.findAll(/* filters */).then((values) {
      emit(WalletBlocList(credentials: values));
    });
  }

  void convertInWalletBlocList(List<CredentialModel> credentials) {
    emit(WalletBlocList(credentials: credentials));
  }

  Future checkKey() async {
    final key = await SecureStorageProvider.instance.get('key');
    if (key == null) {
      emit(WalletBlocCreateKey());
    } else {
      if (key.isEmpty) {
        emit(WalletBlocCreateKey());
      } else {
        /// When app is initialized, set all credentials with active status to unknown status
        await repository.initializeRevocationStatus();

        /// load all credentials from repository
        await repository.findAll(/* filters */).then((values) {
          emit(WalletBlocListReady(credentials: values));
        });
      }
    }
  }

  Future deleteById(String id) async {
    await repository.deleteById(id);
    await findAll();
  }

  Future updateCredential(CredentialModel credential) async {
    await repository.update(credential);
    await findAll();
  }

  Future insertCredential(CredentialModel credential) async {
    await repository.insert(credential);
    await findAll();
  }

  void dispose() {
    print('dispose wallet bloc ?');
  }

  Future deleteAll() async {
    await repository.deleteAll();
    await findAll();
  }
}
