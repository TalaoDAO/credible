import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';

import 'global_information_state.dart';

class GlobalInformationCubit extends Cubit<GlobalInformationState> {
  final SecureStorageProvider secureStorageProvider;

  GlobalInformationCubit(this.secureStorageProvider)
      : super(GlobalInformationState()) {
    init();
  }

  Future<void> init() async {
    final isEnterpriseUser =
        (await secureStorageProvider.get(SecureStorageKeys.isEnterpriseUser)) ==
            'true';
    emit(GlobalInformationState(isEnterpriseUser: isEnterpriseUser));
  }
}
