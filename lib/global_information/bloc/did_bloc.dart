import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';

part 'did_event.dart';

class DIDBloc extends Bloc<DIDEvent, DIDState> {
  final SecureStorageProvider? secureStorageProvider;
  final DIDKitProvider? didKitProvider;

  DIDBloc({this.didKitProvider, this.secureStorageProvider})
      : super(DIDStateDefault('')) {
    on<DIDEventLoad>(_load);
    add(DIDEventLoad());
  }

  void _load(
    DIDEventLoad event,
    Emitter<DIDState> emit,
  ) async {
    final log = Logger('talao-wallet/DID/load');

    try {
      emit(DIDStateWorking());

      final key = (await secureStorageProvider!.get('key'))!;
      final DID = didKitProvider!.keyToDID(Constants.defaultDIDMethod, key);

      emit(DIDStateDefault(DID));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(DIDStateMessage(StateMessage.error('Failed to load DID. '
          'Check the logs for more information.')));
    }
  }
}
