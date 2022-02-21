import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/pages/profile/models/profile.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/app/shared/widget/base/page.dart';

class AddCredentialPage extends StatelessWidget {
  final ProfileModel profileModel;

  const AddCredentialPage({Key? key, required this.profileModel})
      : super(key: key);

  static Route route(ProfileModel profileModel) => MaterialPageRoute(
        builder: (context) => AddCredentialPage(
          profileModel: profileModel,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocListener<ProfileBloc, ProfileState>(
        listener: (_, state) {
          if (state is ProfileStateSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message.message)));
            Navigator.of(context).pop();
          }else if(state is ProfileStateMessage) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message.message)));
          }
        },
        child: BasePage(
          padding: const EdgeInsets.all(24.0),
          title: localizations.credentialReceiveTitle,
          scrollView: false,
          titleTrailing: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
          body: Column(
            children: [
              const Spacer(),
              ProfileDataCard(profileModel: profileModel),
              const Spacer(),
              BaseButton.primary(
                context: context,
                onPressed: () async {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileDataEventSubmit(profileModel));
                },
                child: Text(localizations.credentialReceiveConfirm),
              ),
              const SizedBox(height: 8.0),
              BaseButton.transparent(
                context: context,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(localizations.credentialReceiveCancel),
              ),
            ],
          ),
        ));
  }
}

class ProfileDataCard extends StatelessWidget {
  final ProfileModel profileModel;

  const ProfileDataCard({Key? key, required this.profileModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      decoration: BaseBoxDecoration(
        color: Theme.of(context).cardColor,
        shapeColor: Theme.of(context).colorScheme.documentShape,
        value: 0.0,
        shapeSize: 256.0,
        anchors: <Alignment>[
          Alignment.topRight,
          Alignment.bottomCenter,
        ],
        // value: animation.value,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.documentShadow,
            blurRadius: 2,
            spreadRadius: 1.0,
            offset: Offset(3, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profileModel.firstName.isNotEmpty
              ? CredentialField(
                  title: localizations.firstName, value: profileModel.firstName)
              : SizedBox.shrink(),
          profileModel.lastName.isNotEmpty
              ? CredentialField(
                  title: localizations.lastName, value: profileModel.lastName)
              : SizedBox.shrink(),
          profileModel.phone.isNotEmpty
              ? CredentialField(
                  title: localizations.personalPhone, value: profileModel.phone)
              : SizedBox.shrink(),
          profileModel.location.isNotEmpty
              ? CredentialField(
                  title: localizations.personalLocation,
                  value: profileModel.location)
              : SizedBox.shrink(),
          profileModel.email.isNotEmpty
              ? CredentialField(
                  title: localizations.personalMail, value: profileModel.email)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
