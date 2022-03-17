import 'wallet_type_enum.dart';

class ChooseWalletTypeState {
  final WalletTypes selectedWallet;

  const ChooseWalletTypeState({required this.selectedWallet});

  ChooseWalletTypeState copyWith({WalletTypes? selectedWallet}) {
    return ChooseWalletTypeState(
        selectedWallet: selectedWallet ?? this.selectedWallet);
  }
}
