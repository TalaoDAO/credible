import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:talao/app/pages/profile/blocs/did.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/pages/profile/widgets/menu_item.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Modular.get<ProfileBloc>().add(ProfileEventLoad());
    Modular.get<DIDBloc>().add(DIDEventLoad());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocConsumer(
      bloc: Modular.get<ProfileBloc>(),
      listener: (context, state) {
        if (state is ProfileStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
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
                    style: Theme.of(context).textTheme.subtitle2!,
                  ),
                ),
              const SizedBox(height: 32.0),
              MenuItem(
                icon: Icons.person,
                title: localizations.personalTitle,
                onTap: () =>
                    Modular.to.pushNamed('/profile/personal', arguments: model),
              ),
              MenuItem(
                icon: Icons.receipt_long,
                title: localizations.globalInformationLabel,
                onTap: () =>
                    Modular.to.pushNamed('/profile/global-information'),
              ),
              MenuItem(
                icon: Icons.shield,
                title: localizations.privacyTitle,
                onTap: () => Modular.to.pushNamed('/profile/privacy'),
              ),
              MenuItem(
                icon: Icons.article,
                title: localizations.onBoardingTosTitle,
                onTap: () => Modular.to.pushNamed('/profile/terms'),
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
                    await Modular.to.pushNamed('/profile/recovery');
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

                    final repository = Modular.get<CredentialsRepository>();
                    await repository.deleteAll();

                    await Modular.to.pushReplacementNamed('/splash');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
