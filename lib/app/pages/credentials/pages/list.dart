import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/list_item.dart';
import 'package:talao/app/pages/qr_code/bloc/qrcode.dart';
import 'package:talao/app/pages/qr_code/check_host.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/pages/profile/usecase/is_issuer_approved.dart'
    as issuer_approved_usecase;
import 'package:talao/deep_link/cubit/deep_link.dart';

class CredentialsList extends StatelessWidget {
  final List<CredentialModel> items;

  const CredentialsList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext credentialListContext) {
    final localizations = AppLocalizations.of(credentialListContext)!;

    /// If there is a deepLink we give do as if it comming from QRCode
    final deepLinkState = credentialListContext.read<DeepLinkCubit>().state;
    if (deepLinkState != '') {
      credentialListContext
          .read<QRCodeBloc>()
          .add(QRCodeEventDeepLink(deepLinkState));
    }
    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      child: BlocListener<QRCodeBloc, QRCodeState>(
        listener: (context, state) async {
          if (state is QRCodeStateHost) {
            credentialListContext.read<DeepLinkCubit>().resetDeepLink();

            var approvedIssuer =
                await issuer_approved_usecase.ApprovedIssuer(state.uri);
            var acceptHost;
            acceptHost = await checkHost(
                    localizations, state.uri, approvedIssuer, context) ??
                false;

            if (acceptHost) {
              context.read<QRCodeBloc>().add(QRCodeEventAccept(state.uri));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(localizations.scanRefuseHost),
              ));
            }
          }
          if (state is QRCodeStateSuccess) {
            await Modular.to.pushReplacementNamed(
              state.route,
              arguments: <String, dynamic>{
                'uri': state.uri,
                'data': state.data ?? '',
              },
            );
          }
        },
        child: BasePage(
          title: localizations.credentialListTitle,
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16.0,
          ),
          navigation: CustomNavBar(index: 0),
          body: Column(
            children: List.generate(
              items.length,
              (index) => CredentialsListItem(item: items[index]),
            ),
          ),
        ),
      ),
    );
  }
}
