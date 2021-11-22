  import 'package:flutter/material.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> checkHost(
      AppLocalizations localizations, Uri uri, Issuer approvedIssuer, BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: localizations.scanPromptHost,
          subtitle: (approvedIssuer.did.isEmpty)
              ? uri.host
              : '${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}',
          yes: localizations.communicationHostAllow,
          no: localizations.communicationHostDeny,
          lock: (uri.scheme == 'http') ? true : false,
        );
      },
    );
  }

