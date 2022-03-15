import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';

class ChooseWalletTypeState {
  final String selectedWallet;

  const ChooseWalletTypeState({required this.selectedWallet});

  ChooseWalletTypeState copyWith({String? selectedWallet}) {
    return ChooseWalletTypeState(
        selectedWallet: selectedWallet ?? this.selectedWallet);
  }
}

class ChooseWalletTypeCubit extends Cubit<ChooseWalletTypeState> {
  static const walletTypes = ['Personal Wallet', 'Enterprise Wallet'];

  ChooseWalletTypeCubit()
      : super(ChooseWalletTypeState(selectedWallet: walletTypes[0]));

  void onChangeWalletType(String? value) {
    emit(state.copyWith(selectedWallet: value));

    //save isEnterprise, DIDMethod and DIDMethodName
    if (isPersonalWalletSelected()) {
      SecureStorageProvider.instance
          .set(SecureStorageKeys.isEnterpriseUser, false.toString());
      SecureStorageProvider.instance
          .set(SecureStorageKeys.DIDMethod, Constants.defaultDIDMethod);
      SecureStorageProvider.instance
          .set(SecureStorageKeys.DIDMethodName, Constants.defaultDIDMethodName);
    } else {
      SecureStorageProvider.instance
          .set(SecureStorageKeys.isEnterpriseUser, true.toString());
      SecureStorageProvider.instance
          .set(SecureStorageKeys.DIDMethod, Constants.enterpriseDIDMethod);
      SecureStorageProvider.instance.set(
          SecureStorageKeys.DIDMethodName, Constants.enterpriseDIDMethodName);
    }
  }

  bool isPersonalWalletSelected() {
    return state.selectedWallet == walletTypes[0];
  }
}
