import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/blocs/wallet.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/list_item.dart';

import 'package:talao/app/pages/qr_code/bloc/qrcode.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';

class CredentialsList extends StatefulWidget {
  const CredentialsList({
    Key? key,
  }) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => CredentialsList(),
      );

  @override
  State<CredentialsList> createState() => _CredentialsListState();
}

class _CredentialsListState extends State<CredentialsList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it comming from QRCode
      final deepLinkState = context.read<DeepLinkCubit>().state;
      if (deepLinkState != '') {
        context.read<DeepLinkCubit>().resetDeepLink();
        context.read<QRCodeBloc>().add(QRCodeEventDeepLink(deepLinkState));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext credentialListContext) {
    final localizations = AppLocalizations.of(credentialListContext)!;

    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      child: BasePage(
        title: localizations.credentialListTitle,
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ),
        navigation: CustomNavBar(index: 0),
        body: BlocBuilder<WalletBloc, WalletBlocState>(
          builder: (context, state) {
            var _credentialList = <CredentialModel>[];
            if (state is WalletBlocList) {
              _credentialList = state.credentials;
            } else {
              _credentialList = [];
            }
            return Column(
              children: List.generate(
                _credentialList.length,
                (index) => CredentialsListItem(item: _credentialList[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
