import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/profile/profile.dart';
import 'package:talao/app/pages/qr_code/scan.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/info_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class _CustomNavIcon extends StatelessWidget {
  final String asset;

  const _CustomNavIcon({
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 0.33,
        child: _CustomActiveNavIcon(asset: asset),
      );
}

class _CustomActiveNavIcon extends StatelessWidget {
  final String asset;

  const _CustomActiveNavIcon({
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 24.0,
        height: 24.0,
        child: SvgPicture.asset(
          asset,
          color: Theme.of(context).colorScheme.selectedBottomBar,
        ),
      );
}

class CustomNavBar extends StatelessWidget {
  final int index;

  static const String assetWallet = 'assets/icon/wallet.svg';
  static const String assetWalletFilled = 'assets/icon/wallet-filled.svg';
  static const String assetQrCode = 'assets/icon/qr-code.svg';
  static const String assetProfile = 'assets/icon/profile.svg';
  static const String assetProfileFilled = 'assets/icon/profile-filled.svg';

  const CustomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: UiConstraints.navBarPadding,
      decoration: BoxDecoration(
        borderRadius: UiConstraints.navBarRadius,
      ),
      child: BottomNavigationBar(
        currentIndex: index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 5.0,
        onTap: (newIndex) {
          if (newIndex == index) return;
          switch (newIndex) {
            case 0:
              Navigator.of(context).pushReplacement(CredentialsList.route());
              break;
            case 1:
              if (kIsWeb) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => InfoDialog(
                    title: localizations.unavailable_feature_title,
                    subtitle: localizations.unavailable_feature_message,
                    button: localizations.ok,
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(QrCodeScanPage.route());
              }
              break;
            case 2:
              Navigator.of(context).pushReplacement(ProfilePage.route());
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: localizations.credentialDetailListTitle,
            icon: _CustomNavIcon(asset: assetWallet),
            activeIcon: _CustomActiveNavIcon(asset: assetWalletFilled),
          ),
          BottomNavigationBarItem(
            label: 'QR Code',
            icon: _CustomNavIcon(asset: assetQrCode),
            activeIcon: _CustomActiveNavIcon(asset: assetQrCode),
          ),
          BottomNavigationBarItem(
            label: localizations.profileTitle,
            icon: _CustomNavIcon(asset: assetProfile),
            activeIcon: _CustomActiveNavIcon(asset: assetProfileFilled),
          ),
        ],
      ),
    );
  }
}
