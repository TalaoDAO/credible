import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/list_item.dart';
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
        settings: RouteSettings(name: '/credibleList'),
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

    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: BasePage(
        scaffoldKey: scaffoldKey,
        title: localizations.credentialListTitle,
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
                    title: localizations.unavailable_feature_title,
                    subtitle: localizations.unavailable_feature_message,
                    button: localizations.ok,
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
    );
  }
}
