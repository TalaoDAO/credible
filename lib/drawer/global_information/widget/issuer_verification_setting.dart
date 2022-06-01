import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/enum/issuer_verification_registry.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';

class IssuerVerificationSetting extends StatelessWidget {
  IssuerVerificationSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<ProfileCubit, ProfileState>(
        bloc: context.read<ProfileCubit>(),
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: state.message!.color,
              content: Text(state.message?.getMessage(context) ?? ''),
            ));
          }
        },
        builder: (context, state) {
          var groupValue = IssuerVerificationRegistry.talao;
          switch (state.model.issuerVerificationUrl) {
            case '':
              groupValue = IssuerVerificationRegistry.none;
              break;
            case Constants.checkIssuerEbsiUrl:
              groupValue = IssuerVerificationRegistry.ebsi;
              break;
          }
          final String fakeGroupValue = 'titi';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  localizations.issuerVerificationSetting,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry:
                        IssuerVerificationRegistry.talao,
                    groupValue: groupValue,
                  ),
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry: IssuerVerificationRegistry.ebsi,
                    groupValue: groupValue,
                  ),
                  ListTile(
                    title: Text(
                      'Compellio',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.grey),
                    ),
                    trailing: Radio<String>(
                      value: 'useless',
                      groupValue: fakeGroupValue,
                      onChanged: null,
                    ),
                  ),
                  IssuerVerificationRegistrySelector(
                    issuerVerificationRegistry: IssuerVerificationRegistry.none,
                    groupValue: groupValue,
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class IssuerVerificationRegistrySelector extends StatefulWidget {
  IssuerVerificationRegistrySelector({
    Key? key,
    required this.issuerVerificationRegistry,
    required this.groupValue,
  }) : super(key: key);

  final IssuerVerificationRegistry issuerVerificationRegistry;
  final IssuerVerificationRegistry groupValue;

  @override
  State<IssuerVerificationRegistrySelector> createState() =>
      _IssuerVerificationRegistrySelectorState();
}

class _IssuerVerificationRegistrySelectorState
    extends State<IssuerVerificationRegistrySelector> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ListTile(
          title: Text(
            widget.issuerVerificationRegistry.name,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: Radio<IssuerVerificationRegistry>(
            value: widget.issuerVerificationRegistry,
            groupValue: widget.groupValue,
            onChanged: (IssuerVerificationRegistry? value) async {
              if (value != null) {
                await context
                    .read<ProfileCubit>()
                    .updateIssuerVerificationUrl(value);
              }
            },
          ),
        );
      },
    );
  }
}
