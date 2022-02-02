import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:flutter/material.dart';

typedef CredentialsStreamBuilder = Widget Function(
  BuildContext,
  List<CredentialModel>,
);

class CredentialsStream extends StatelessWidget {
  final CredentialsStreamBuilder child;

  const CredentialsStream({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<WalletBloc, WalletBlocState>(builder: (context, walletState) {
        return child(context, walletState.credentials);
      });
}
