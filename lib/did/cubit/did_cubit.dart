import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:talao/did/cubit/did_state.dart';

class DIDCubit extends Cubit<DIDState> {
  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;

  DIDCubit({required this.didKitProvider, required this.secureStorageProvider})
      : super(DIDState());

  void set({
    required String did,
    required String didMethod,
    required String didMethodName,
  }) async {
    final log = Logger('talao-wallet/DID/set');

    emit(DIDStateWorking());
    await secureStorageProvider.set(SecureStorageKeys.did, did);
    await secureStorageProvider.set(SecureStorageKeys.didMethod, didMethod);
    await secureStorageProvider.set(
        SecureStorageKeys.didMethodName, didMethodName);
    emit(DIDStateDefault(
        did: did, didMethod: didMethod, didMethodName: didMethodName));

    log.info('successfully Set');
  }

  void load({
    required String did,
    required String didMethod,
    required String didMethodName,
  }) async {
    final log = Logger('talao-wallet/DID/load');
    emit(DIDStateWorking());
    emit(DIDStateDefault(
        did: did, didMethod: didMethod, didMethodName: didMethodName));

    log.info('successfully Loaded');
  }
}
