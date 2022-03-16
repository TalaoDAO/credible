import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/did/cubit/did_state.dart';
import 'package:talao/scan/cubit/scan_message_string_state.dart';

class DIDCubit extends Cubit<DIDState> {
  final SecureStorageProvider? secureStorageProvider;
  final DIDKitProvider? didKitProvider;

  DIDCubit({this.didKitProvider, this.secureStorageProvider})
      : super(DIDStateDefault(did: '')) {
    load();
  }

  void load() async {
    final log = Logger('talao-wallet/DID/load');

    try {
      emit(DIDStateWorking());

      final DID = (await secureStorageProvider!.get(SecureStorageKeys.did))!;

      emit(DIDStateDefault(did: DID));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(DIDStateMessage(
          message: StateMessage.error(message: ScanMessageStringState.failedToLoadDID())));
    }
  }
}
