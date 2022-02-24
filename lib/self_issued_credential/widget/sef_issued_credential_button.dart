import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  SelfIssuedCredentialDataModel({
    this.givenName,
    this.familyName,
    this.telephone,
    this.email,
    this.address,
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
    return BlocProvider<SelfIssuedCredentialCubit>(
      create: (_) => SelfIssuedCredentialCubit(
        BlocProvider.of<WalletCubit>(context),
      ),
      child: BlocConsumer<SelfIssuedCredentialCubit, SelfIssuedCredentialState>(
          builder: (ctx, state) {
        return FloatingActionButton(
          onPressed: () {
            state.maybeWhen(
                orElse: () {
                  BlocProvider.of<SelfIssuedCredentialCubit>(ctx)
                      .createSelfIssuedCredential(
                          selfIssuedCredentialDataModel:
                              selfIssuedCredentialButtonClick.call());
                },
                loading: () => null);
          },
          child: Builder(builder: (_) {
            return state.maybeWhen(
                orElse: () => Icon(Icons.vpn_key),
                loading: () => Center(child: CircularProgressIndicator()));
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
              //todo move the text to AppLocalization
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content:
                      Text('self issued credential created successfully')));
            });
      }),
    );
  }
}
