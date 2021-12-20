import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/pages/profile/models/profile.dart';

class IssuerVerificationSetting extends StatelessWidget {
  const IssuerVerificationSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer(
        bloc: context.read<ProfileBloc>(),
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
          final issuerVerificationSetting = model.issuerVerificationSetting;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(localizations.issuerVerificationSetting),
                Spacer(),
                Switch(
                  onChanged: (value) {
                    context.read<ProfileBloc>().add(ProfileEventUpdate(ProfileModel(
                      firstName: model.firstName,
                      lastName: model.lastName,
                      phone: model.phone,
                      location: model.location,
                      email: model.email,
                      issuerVerificationSetting: value,
                    )));
                  },
                  value: issuerVerificationSetting,
                ),
              ],
            ),
          );
        });
  }
}
