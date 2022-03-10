import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/credentials/widget/list_item.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/info_dialog.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/drawer/profile/view/profile_page.dart';

class CredentialsList extends StatefulWidget {
  const CredentialsList({
    Key? key,
  }) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => CredentialsList(),
        settings: RouteSettings(name: '/credentialsList'),
      );

  @override
  State<CredentialsList> createState() => _CredentialsListState();
}

class _CredentialsListState extends State<CredentialsList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      /// If there is a deepLink we give do as if it coming from QRCode
      final deepLinkCubit = context.read<DeepLinkCubit>();
      final deepLinkString = deepLinkCubit.state;
      if (deepLinkString != '') {
        deepLinkCubit.resetDeepLink();
        context.read<QRCodeScanCubit>().deepLink(deepLinkString);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext credentialListContext) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<QRCodeScanCubit, QRCodeScanState>(
              listener: (context, state) async {
            if (state.isDeepLink!) {
              if (state is QRCodeScanStateHost) {
                var approvedIssuer = await context
                    .read<QRCodeScanCubit>()
                    .isApprovedIssuer(state.uri!, context);
                var acceptHost = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          title: l10n.scanPromptHost,
                          subtitle: (approvedIssuer.did.isEmpty)
                              ? state.uri!.host
                              : '${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}',
                          yes: l10n.communicationHostAllow,
                          no: l10n.communicationHostDeny,
                          lock: (state.uri!.scheme == 'http') ? true : false,
                        );
                      },
                    ) ??
                    false;

                if (acceptHost) {
                  context.read<QRCodeScanCubit>().accept(state.uri!, true);
                } else {
                  //await qrController.resumeCamera();
                  context.read<QRCodeScanCubit>().emitWorkingState();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l10n.scanRefuseHost),
                  ));
                }
              }
              if (state is QRCodeScanStateSuccess) {
                //   await qrController.stopCamera();
                await Navigator.of(context).pushReplacement(state.route!);
              }
              if (state is QRCodeScanStateMessage) {
                //   await qrController.resumeCamera();
                final errorHandler = state.message!.errorHandler;
                if (errorHandler != null) {
                  final color = state.message!.color ??
                      Theme.of(context).colorScheme.error;
                  errorHandler.displayError(context, errorHandler, color);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: state.message!.color,
                    content: Text(state.message!.message!),
                  ));
                }
              }
              if (state is QRCodeScanStateUnknown) {
                //   await qrController.resumeCamera();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(l10n.scanUnsupportedMessage),
                ));
              }
            }
          })
        ],
        child: BasePage(
          scaffoldKey: scaffoldKey,
          title: l10n.credentialListTitle,
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16.0,
          ),
          drawer: ProfilePage(),
          titleLeading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
          ),
          titleTrailing: IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {
                if (kIsWeb) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => InfoDialog(
                      title: l10n.unavailable_feature_title,
                      subtitle: l10n.unavailable_feature_message,
                      button: l10n.ok,
                    ),
                  );
                } else {
                  Navigator.of(context).push(QrCodeScanPage.route());
                }
              }),
          body: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
              var _credentialList = <CredentialModel>[];
              _credentialList = state.credentials;
              return Column(
                children: List.generate(
                  _credentialList.length,
                  (index) => CredentialsListItem(item: _credentialList[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
