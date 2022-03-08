import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/self_issued_credential/bloc/self_issued_credential.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

typedef SelfIssuedCredentialButtonClick = SelfIssuedCredentialDataModel
    Function();

class SelfIssuedCredentialDataModel {
  final String? givenName;
  final String? familyName;
  final String? telephone;
  final String? email;
  final String? address;
  final String? companyName;
  final String? companyWebsite;
  final String? jobTitle;

  SelfIssuedCredentialDataModel({
    this.givenName,
    this.familyName,
    this.telephone,
    this.email,
    this.address,
    this.companyName,
    this.companyWebsite,
    this.jobTitle,
  });

  @override
  String toString() {
    return '''
    SelfIssuedCredentialDataModel {
                  givenName : $givenName,
                  familyName : $familyName,
                  telephone : $telephone,
                  email : $email,
                  address : $address,
                  companyName : $companyName,
                  companyWebsite : $companyWebsite,
                  jobTitle : $jobTitle,
    }
    ''';
  }
}

class SelfIssuedCredentialButton extends StatelessWidget {
  final SelfIssuedCredentialButtonClick selfIssuedCredentialButtonClick;

  const SelfIssuedCredentialButton(
      {Key? key, required this.selfIssuedCredentialButtonClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = context.l10n;
    return BlocProvider<SelfIssuedCredentialCubit>(
      create: (_) => SelfIssuedCredentialCubit(
        context.read<WalletCubit>(),
      ),
      child: BlocConsumer<SelfIssuedCredentialCubit, SelfIssuedCredentialState>(
          builder: (ctx, state) {
        return FloatingActionButton(
          onPressed: () {
            state.maybeWhen(
                orElse: () {
                  ctx
                      .read<SelfIssuedCredentialCubit>()
                      .createSelfIssuedCredential(
                          selfIssuedCredentialDataModel:
                              selfIssuedCredentialButtonClick.call());
                },
                loading: () => null);
          },
          child: Builder(builder: (_) {
            return state.maybeWhen(
                orElse: () => Icon(Icons.fact_check_outlined),
                loading: () =>
                    Center(child: CircularProgressIndicator.adaptive()));
          }),
        );
      }, listener: (ctx, state) {
        state.maybeWhen(
            orElse: () => null,
            error: (message) {
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
            warning: (message) {
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
            credentialCreated: () {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: Text(localization.selfIssuedCreatedSuccessfully)));
            });
      }),
    );
  }
}
