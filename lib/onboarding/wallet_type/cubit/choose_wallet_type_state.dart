import 'wallet_type_enum.dart';

class ChooseWalletTypeState {
  final WalletTypes selectedWallet;

  const ChooseWalletTypeState({this.selectedWallet = WalletTypes.personal});

  ChooseWalletTypeState copyWith({WalletTypes? selectedWallet}) {
    return ChooseWalletTypeState(
        selectedWallet: selectedWallet ?? this.selectedWallet);
  }
}
