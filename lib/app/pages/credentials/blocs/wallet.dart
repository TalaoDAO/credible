import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:bloc/bloc.dart';

abstract class WalletBlocState {
  final List<CredentialModel> credentials = [];
}

class WalletBlocInit extends WalletBlocState {
  @override
  final List<CredentialModel> credentials = [];
}

class WalletBlocList extends WalletBlocState {
  @override
  final List<CredentialModel> credentials;
  WalletBlocList({required this.credentials});
}

class WalletBloc extends Cubit<WalletBlocState> {
  final CredentialsRepository repository;

  WalletBloc(this.repository) : super(WalletBlocInit()) {
    /// When app is initialized, set all credentials with active status to unknown status
    repository.initializeRevocationStatus();

    /// load all credentials from repository
    findAll();
  }

  Future findAll(/* dynamic filters */) async {
    await repository.findAll(/* filters */).then((values) {
      emit(WalletBlocList(credentials: values));
    });
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
