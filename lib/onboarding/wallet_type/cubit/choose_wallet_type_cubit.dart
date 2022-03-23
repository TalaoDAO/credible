import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/onboarding/wallet_type/cubit/wallet_type_enum.dart';

import 'choose_wallet_type_state.dart';

class ChooseWalletTypeCubit extends Cubit<ChooseWalletTypeState> {
  final SecureStorageProvider secureStorageProvider;

  ChooseWalletTypeCubit(this.secureStorageProvider)
      : super(ChooseWalletTypeState());

  void onChangeWalletType(WalletTypes walletType) {
    save(walletType);
    emit(state.copyWith(selectedWallet: walletType));
  }

  Future<void> save(WalletTypes walletType) async {
    if (walletType == WalletTypes.personal) {
      await secureStorageProvider.set(
          SecureStorageKeys.isEnterpriseUser, false.toString());
    } else {
      await secureStorageProvider.set(
          SecureStorageKeys.isEnterpriseUser, true.toString());
    }
  }
}
