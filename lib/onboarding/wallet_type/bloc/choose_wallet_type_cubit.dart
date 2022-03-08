import 'package:bloc/bloc.dart';

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
  }

  bool isPersonalWalletSelected() {
    return state.selectedWallet == walletTypes[0];
  }
}
