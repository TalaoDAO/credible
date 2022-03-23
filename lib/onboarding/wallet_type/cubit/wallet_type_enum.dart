import 'package:flutter/material.dart' show BuildContext;
import 'package:talao/l10n/l10n.dart';

enum WalletTypes { personal, enterprise }

extension WalletTypesX on WalletTypes {
  String stringValue(BuildContext context) {
    final localization = context.l10n;
    if (this == WalletTypes.enterprise) {
      return localization.enterpriseWallet;
    } else {
      return localization.personalWallet;
    }
  }
}
