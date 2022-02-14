import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/pages/profile/pages/global_information.dart';
import 'package:talao/app/pages/profile/pages/personal.dart';
import 'package:talao/app/pages/profile/pages/privacy.dart';
import 'package:talao/app/pages/profile/pages/recovery.dart';
import 'package:talao/app/pages/profile/pages/terms.dart';
import 'package:talao/app/pages/profile/pages/theme.dart';
import 'package:talao/app/pages/profile/widgets/menu_item.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/theme/cubit/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => ProfilePage(),
      );

  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocConsumer(
      bloc: context.read<ProfileBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        final model =
            state is ProfileStateDefault ? state.model : ProfileModel();
        final firstName = model.firstName;
        final lastName = model.lastName;

        return BasePage(
          title: localizations.profileTitle,
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
          ),
          navigation: CustomNavBar(index: 2),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Center(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width * 0.2,
              //     height: MediaQuery.of(context).size.width * 0.2,
              //     decoration: BoxDecoration(
              //       color: Colors.pink,
              //       borderRadius: BorderRadius.circular(16.0),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16.0),
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
                title: localizations.personalTitle,
                onTap: () =>
                    Navigator.of(context).push(PersonalPage.route(model)),
              ),
              MenuItem(
                icon: Icons.receipt_long,
                title: localizations.globalInformationLabel,
                onTap: () =>
                    Navigator.of(context).push(GlobalInformationPage.route()),
              ),
              MenuItem(
                icon: Icons.shield,
                title: localizations.privacyTitle,
                onTap: () => Navigator.of(context).push(PrivacyPage.route()),
              ),
              MenuItem(
                icon: Icons.article,
                title: localizations.onBoardingTosTitle,
                onTap: () => Navigator.of(context).push(TermsPage.route()),
              ),
              MenuItem(
                icon: Icons.vpn_key,
                title: localizations.recoveryTitle,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: localizations.recoveryWarningDialogTitle,
                          subtitle: localizations.recoveryWarningDialogSubtitle,
                          yes: localizations.showDialogYes,
                          no: localizations.showDialogNo,
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
                title: localizations.resetWalletButton,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: localizations.resetWalletButton,
                          subtitle: localizations.resetWalletConfirmationText,
                          yes: localizations.showDialogYes,
                          no: localizations.showDialogNo,
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
                title: localizations.selectThemeText,
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
