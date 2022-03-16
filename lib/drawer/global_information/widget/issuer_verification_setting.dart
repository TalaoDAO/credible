import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';
import 'package:talao/drawer/profile/models/profile.dart';


class IssuerVerificationSetting extends StatelessWidget {
  const IssuerVerificationSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer(
        bloc: context.read<ProfileCubit>(),
        listener: (context, state) {
          if (state is ProfileStateMessage) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: state.message!.color,
              content: Text(state.message?.getMessage(context) ?? ''),
            ));
          }
        },
        builder: (context, state) {
          final model =
              state is ProfileStateDefault ? state.model : ProfileModel.empty;
          final issuerVerificationSetting = model!.issuerVerificationSetting;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  localizations.issuerVerificationSetting,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Spacer(),
                Switch(
                  onChanged: (value) {
                    var profileModel = ProfileModel(
                      firstName: model.firstName,
                      lastName: model.lastName,
                      phone: model.phone,
                      location: model.location,
                      email: model.email,
                      issuerVerificationSetting: value,
                    );
                    context.read<ProfileCubit>().update(profileModel);
                  },
                  value: issuerVerificationSetting,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          );
        });
  }
}
