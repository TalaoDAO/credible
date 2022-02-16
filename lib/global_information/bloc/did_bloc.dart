import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';

part 'didkit_event.dart';

class DIDKitBloc extends Bloc<DIDKitEvent, DIDKitState> {
  DIDKitBloc() : super(DIDKitStateDefault('')) {
    on<DIDKitEventLoad>(_load);
    add(DIDKitEventLoad());
  }

  void _load(
    DIDKitEventLoad event,
    Emitter<DIDKitState> emit,
  ) async {
    final log = Logger('talao-wallet/DIDKit/load');

    try {
      emit(DIDKitStateWorking());

      final key = (await SecureStorageProvider.instance.get('key'))!;
      final DIDKit =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);

      emit(DIDKitStateDefault(DIDKit));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(DIDKitStateMessage(StateMessage.error('Failed to load DIDKit. '
          'Check the logs for more information.')));
    }
  }
}
