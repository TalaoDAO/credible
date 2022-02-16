import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/profile/models/profile.dart';
import 'package:talao/app/pages/profile/pages/global_information.dart';
import 'package:talao/app/pages/profile/pages/personal.dart';
import 'package:talao/app/pages/profile/pages/privacy.dart';
import 'package:talao/app/pages/profile/pages/recovery.dart';
import 'package:talao/app/pages/profile/pages/terms.dart';
import 'package:talao/app/pages/profile/pages/theme.dart';
import 'package:talao/profile/view/menu_item.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/profile/profile.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer(
      bloc: context.read<ProfileBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        final model =
            state is ProfileStateDefault ? state.model : ProfileModel();
        final firstName = model.firstName;
        final lastName = model.lastName;

        return BasePage(
          title: l10n.profileTitle,
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
          ),
          navigation: CustomNavBar(index: 2),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (firstName.isNotEmpty || lastName.isNotEmpty)
                Center(
                  child: Text(
                    '$firstName $lastName',
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
                ),
              const SizedBox(height: 32.0),
              MenuItem(
                icon: Icons.person,
                title: l10n.personalTitle,
                onTap: () =>
                    Navigator.of(context).push(PersonalPage.route(model)),
              ),
              MenuItem(
                icon: Icons.receipt_long,
                title: l10n.globalInformationLabel,
                onTap: () =>
                    Navigator.of(context).push(GlobalInformationPage.route()),
              ),
              MenuItem(
                icon: Icons.shield,
                title: l10n.privacyTitle,
                onTap: () => Navigator.of(context).push(PrivacyPage.route()),
              ),
              MenuItem(
                icon: Icons.article,
                title: l10n.onBoardingTosTitle,
                onTap: () => Navigator.of(context).push(TermsPage.route()),
              ),
              MenuItem(
                icon: Icons.vpn_key,
                title: l10n.recoveryTitle,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: l10n.recoveryWarningDialogTitle,
                          subtitle: l10n.recoveryWarningDialogSubtitle,
                          yes: l10n.showDialogYes,
                          no: l10n.showDialogNo,
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    await Navigator.of(context).push(RecoveryPage.route());
                  }
                },
              ),
              MenuItem(
                icon: Icons.settings_backup_restore,
                title: l10n.resetWalletButton,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: l10n.resetWalletButton,
                          subtitle: l10n.resetWalletConfirmationText,
                          yes: l10n.showDialogYes,
                          no: l10n.showDialogNo,
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    await SecureStorageProvider.instance.delete('key');
                    await SecureStorageProvider.instance.delete('mnemonic');
                    await SecureStorageProvider.instance.delete('data');

                    await SecureStorageProvider.instance
                        .delete(ProfileModel.firstNameKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.lastNameKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.phoneKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.locationKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.emailKey);

                    await context.read<WalletBloc>().deleteAll();

                    await Navigator.of(context).push(SplashPage.route());
                  }
                },
              ),
              MenuItem(
                key: Key('theme_update'),
                icon: Icons.light_mode,
                title: l10n.selectThemeText,
                onTap: () => Navigator.of(context)
                    .push(ThemePage.route(context.read<ThemeCubit>())),
              ),
            ],
          ),
        );
      },
    );
  }
}
