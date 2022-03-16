import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/onboarding/wallet_type/cubit/wallet_type_enum.dart';

import 'choose_wallet_type_state.dart';

class ChooseWalletTypeCubit extends Cubit<ChooseWalletTypeState> {
  ChooseWalletTypeCubit()
      : super(ChooseWalletTypeState(selectedWallet: WalletTypes.personal));

  void onChangeWalletType(WalletTypes? value) {
    emit(state.copyWith(selectedWallet: value));

    //save isEnterprise, DIDMethod and DIDMethodName
    if (isPersonalWalletSelected()) {
      SecureStorageProvider.instance
          .set(SecureStorageKeys.isEnterpriseUser, false.toString());
    } else {
      SecureStorageProvider.instance
          .set(SecureStorageKeys.isEnterpriseUser, true.toString());
    }
  }

  bool isPersonalWalletSelected() {
    return state.selectedWallet == WalletTypes.personal;
  }
}
