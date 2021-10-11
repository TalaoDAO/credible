import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc extends Disposable {
  final CredentialsRepository repository;

  WalletBloc(this.repository);

  BehaviorSubject<List<CredentialModel>> credentials$ =
      BehaviorSubject<List<CredentialModel>>();

  Future findAll(/* dynamic filters */) async {
    await repository.findAll(/* filters */).then((values) {
      credentials$.add(values);
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

  @override
  void dispose() {
    print('dispose wallet bloc ?');
    //Temporary removed: cause loosing repository when we replace a route.
    // credentials$.close();
  }
}
