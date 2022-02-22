import 'dart:convert';

import 'package:provider/src/provider.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/models/verification_state.dart';
import 'package:talao/app/pages/credentials/widget/display_status.dart';
import 'package:talao/app/pages/credentials/widget/document.dart';
import 'package:talao/app/pages/qr_code/display.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:talao/app/shared/widget/text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

class CredentialsDetail extends StatefulWidget {
  final CredentialModel item;

  const CredentialsDetail({
    Key? key,
    required this.item,
  }) : super(key: key);

  static Route route(CredentialModel routeItem) {
    return MaterialPageRoute(
      builder: (context) => CredentialsDetail(
        item: routeItem,
      ),
    );
  }

  @override
  _CredentialsDetailState createState() => _CredentialsDetailState();
}

class _CredentialsDetailState extends State<CredentialsDetail> {
  bool showShareMenu = false;
  VerificationState verification = VerificationState.Unverified;

  String? title = '';

  final logger = Logger('talao-wallet/credentials/detail');

  @override
  void initState() {
    super.initState();
    title = widget.item.alias;
    verify();
  }

  void verify() async {
    final vcStr = jsonEncode(widget.item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final result =
        await DIDKitProvider.instance.verifyCredential(vcStr, optStr);
    final jsonResult = jsonDecode(result);

    if (jsonResult['warnings'].isNotEmpty) {
      setState(() {
        verification = VerificationState.VerifiedWithWarning;
      });
    } else if (jsonResult['errors'].isNotEmpty) {
      if (jsonResult['errors'][0] == 'No applicable proof') {
        setState(() {
          verification = VerificationState.Unverified;
        });
      } else {
        setState(() {
          verification = VerificationState.VerifiedWithError;
        });
      }
    } else {
      setState(() {
        verification = VerificationState.Verified;
      });
    }
  }

  void delete() async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            final localizations = AppLocalizations.of(context)!;
            return ConfirmDialog(
              title: localizations.credentialDetailDeleteConfirmationDialog,
              yes: localizations.credentialDetailDeleteConfirmationDialogYes,
              no: localizations.credentialDetailDeleteConfirmationDialogNo,
            );
          },
        ) ??
        false;

    if (confirm) {
      await context.read<WalletCubit>().deleteById(widget.item.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text('Successfully deleted'),
      ));
    }
  }

  void _edit() async {
    logger.info('Start edit flow');

    final newAlias = await showDialog<String>(
      context: context,
      builder: (context) => TextFieldDialog(
        title: 'Do you want to edit this credential alias?',
        initialValue: title,
        yes: 'Save',
        no: 'Cancel',
      ),
    );

    logger.info('Edit flow answered with: $newAlias');

    if (newAlias != null && newAlias != title) {
      logger.info('New alias is different, going to update credential');
    }
    final newCredential = CredentialModel.copyWithAlias(
      oldCredentialModel: widget.item,
      newAlias: newAlias ?? '',
    );
    await context.read<WalletCubit>().updateCredential(newCredential);
    setState(() {
      title = newAlias;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully updated'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context)!;
    return BasePage(
      title: title != '' ? title : localizations.credential,
      titleTag: 'credential/${title ?? widget.item.id}/issuer',
      titleLeading: BackLeadingButton(),
      titleTrailing: IconButton(
        onPressed: _edit,
        icon: Icon(Icons.edit),
      ),
      navigation: widget.item.shareLink != ''
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 5.0,
                ),
                height: kBottomNavigationBarHeight,
                child: Tooltip(
                  message: localizations.credentialDetailShare,
                  child: BaseButton.primary(
                    context: context,
                    onPressed: () {
                      Navigator.of(context).push(
                          QrCodeDisplayPage.route(widget.item.id, widget.item));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/icon/qr-code.svg',
                          width: 24.0,
                          height: 24.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 16.0),
                        Text(localizations.credentialDetailShare),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DocumentWidget(
            model: widget.item,
          ),
          const SizedBox(height: 64.0),
          ...<Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  localizations.credentialDetailStatus,
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    verification.icon,
                    color: verification.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    verification.message,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .apply(color: verification.color),
                  ),
                ),
              ],
            ),
          ],
          Center(
            child: DisplayStatus(widget.item, true),
          ),
          const SizedBox(height: 64.0),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.error.withOpacity(0.1),
            ),
            onPressed: delete,
            child: Text(
              localizations.credentialDetailDelete,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .apply(color: Theme.of(context).colorScheme.error),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
