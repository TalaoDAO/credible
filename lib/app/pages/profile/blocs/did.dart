import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';

abstract class DIDEvent {}

class DIDEventLoad extends DIDEvent {}

abstract class DIDState {}

class DIDStateWorking extends DIDState {}

class DIDStateMessage extends DIDState {
  final StateMessage message;

  DIDStateMessage(this.message);
}

class DIDStateDefault extends DIDState {
  final String did;

  DIDStateDefault(this.did);
}

class DIDBloc extends Bloc<DIDEvent, DIDState> {
  DIDBloc() : super(DIDStateDefault('')) {
    on<DIDEventLoad>(_load);
    add(DIDEventLoad());
  }

  void _load(
    DIDEventLoad event, Emitter<DIDState> emit,
  ) async {
    final log = Logger('talao-wallet/did/load');

    try {
      emit(DIDStateWorking());

      final key = (await SecureStorageProvider.instance.get('key'))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);

      emit(DIDStateDefault(did));
    } catch (e) {
      log.severe('something went wrong', e);

      emit( DIDStateMessage(StateMessage.error('Failed to load DID. '
          'Check the logs for more information.')));
    }
  }
}
