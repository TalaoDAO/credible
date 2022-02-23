import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/self_issued_credential/bloc/self_issued_credential.dart';

class SelfIssuedCredentialButton extends StatelessWidget {
  final String givenName, familyName, telephone, email, address;

  const SelfIssuedCredentialButton(
      {Key? key,
      this.givenName = '',
      this.familyName = '',
      this.telephone = '',
      this.email = '',
      this.address = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelfIssuedCredentialCubit>(
      create: (_) => SelfIssuedCredentialCubit(
          BlocProvider.of<WalletBloc>(context),
          DioClient(Constants.checkIssuerServerUrl, Dio())),
      child: BlocConsumer<SelfIssuedCredentialCubit, SelfIssuedCredentialState>(
          builder: (ctx, state) {
        return FloatingActionButton(
          onPressed: () {
            state.maybeWhen(
                orElse: () {
                  BlocProvider.of<SelfIssuedCredentialCubit>(ctx)
                      .createSelfIssuedCredential(
                          givenName: givenName,
                          familyName: familyName,
                          telephone: telephone,
                          email: email,
                          address: address);
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
