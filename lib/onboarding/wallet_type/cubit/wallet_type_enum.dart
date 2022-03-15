enum WalletTypes { personal, enterprise }

extension WalletTypesX on WalletTypes {
  String stringValue() {
    if (this == WalletTypes.enterprise) {
      return 'Enterprise Wallet';
    } else {
      return 'Personal Wallet';
    }
  }
}
