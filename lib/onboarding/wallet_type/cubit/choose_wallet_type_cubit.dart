import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/onboarding/wallet_type/cubit/wallet_type_enum.dart';

import 'choose_wallet_type_state.dart';

class ChooseWalletTypeCubit extends Cubit<ChooseWalletTypeState> {
  final SecureStorageProvider secureStorageProvider;

  ChooseWalletTypeCubit(this.secureStorageProvider)
      : super(ChooseWalletTypeState(selectedWallet: WalletTypes.personal));

  void onChangeWalletType(WalletTypes? value) {
    emit(state.copyWith(selectedWallet: value));
  }

  Future<void> save() async {
    if (isPersonalWalletSelected()) {
      await secureStorageProvider.set(
          SecureStorageKeys.isEnterpriseUser, false.toString());
      await secureStorageProvider.set(
          SecureStorageKeys.DIDMethod, Constants.defaultDIDMethod);
      await secureStorageProvider.set(
          SecureStorageKeys.DIDMethodName, Constants.defaultDIDMethodName);
    } else {
      await secureStorageProvider.set(
          SecureStorageKeys.isEnterpriseUser, true.toString());
      await secureStorageProvider.set(
          SecureStorageKeys.DIDMethod, Constants.enterpriseDIDMethod);
      await secureStorageProvider.set(
          SecureStorageKeys.DIDMethodName, Constants.enterpriseDIDMethodName);
    }
  }

  bool isPersonalWalletSelected() {
    return state.selectedWallet == WalletTypes.personal;
  }
}
