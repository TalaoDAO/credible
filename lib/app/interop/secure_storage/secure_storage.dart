import 'secure_storage_stub.dart'
    if (dart.library.io) 'secure_storage_io.dart'
    if (dart.library.js) 'secure_storage_js.dart';

abstract class SecureStorageProvider {
  static SecureStorageProvider? _instance;

  static SecureStorageProvider get instance {
    _instance ??= getProvider();
    return _instance!;
  }

  Future<String?> get(String key);

  Future<void> set(String key, String val);

  Future<void> delete(String key);

  Future<Map<String, dynamic>> getAllValues();

  Future<void> deleteAll();
}

abstract class SecureStorageKeys {
  static const isEnterpriseUser = 'isEnterpriseUser';
  static const did = 'DID';
  static const DIDMethod = 'DIDMethod';
  static const DIDMethodName = 'DIDMethodName';
}
