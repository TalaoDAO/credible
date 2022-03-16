import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/self_issued_credential/cubit/self_issued_credential_cubit.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

import '../cubit/self_issued_credential_state.dart';
import 'models/self_issued_credential_model.dart';

typedef SelfIssuedCredentialButtonClick = SelfIssuedCredentialDataModel
    Function();

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
        SecureStorageProvider.instance,
        DIDKitProvider.instance,
      ),
      child: BlocConsumer<SelfIssuedCredentialCubit, SelfIssuedCredentialState>(
          builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            state.maybeWhen(
                orElse: () {
                  context
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
      }, listener: (context, state) {
        state.maybeWhen(
            orElse: () => null,
            error: (errorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(errorState.getMessage(context))));
            },
            credentialCreated: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(localization.selfIssuedCreatedSuccessfully)));
            });
      }),
    );
  }
}
