import 'package:talao/app/pages/credentials/database.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sembast/sembast.dart';

class CredentialsRepository extends Disposable {
  CredentialsRepository();

  Future<List<Map<String, dynamic>>> rawFindAll(/* dynamic filters */) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.find(db);

    return data.map((m) => m.value).toList();
  }

  Future<List<CredentialModel>> findAll(/* dynamic filters */) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.find(db);

    return data.map((m) => CredentialModel.fromJson(m.value)).toList();
  }

  Future<CredentialModel?> findById(String id) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.find(
      db,
      finder: Finder(
        filter: Filter.equals('id', id),
      ),
    );

    if (data.isEmpty) return null;

    return CredentialModel.fromJson(data.first.value);
  }

  Future<int> deleteAll() async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    return await store.delete(db);
  }

  Future<bool> deleteById(String id) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.delete(
      db,
      finder: Finder(
        filter: Filter.equals('id', id),
        limit: 1,
      ),
    );

    return data > 0;
  }

  Future<int> insert(CredentialModel credential) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    return await store.add(db, credential.toJson());
  }

  Future<int> update(CredentialModel credential) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    return await store.update(
      db,
      credential.toJson(),
      finder: Finder(
        filter: Filter.equals('id', credential.id),
        limit: 1,
      ),
    );
  }

  @override
  void dispose() {}
}
