import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/credentials/list/view/credentials_list_page.dart';
import 'package:talao/scan/cubit/scan_cubit.dart';

class AskUserPermissionDIDAuth extends StatefulWidget {
  const AskUserPermissionDIDAuth({
    Key? key,
  }) : super(key: key);

  @override
  State<AskUserPermissionDIDAuth> createState() =>
      _AskUserPermissionDIDAuthState();
}

class _AskUserPermissionDIDAuthState extends State<AskUserPermissionDIDAuth> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final localizations = AppLocalizations.of(context)!;
      final scanCubit = context.read<ScanCubit>();
      final state = scanCubit.state;
      final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmDialog(
              title: localizations.confimrDIDAuth,
              yes: localizations.showDialogYes,
              no: localizations.showDialogNo,
            ),
          ) ??
          false;

      if (confirm && state is ScanStateAskPermissionDIDAuth) {
        scanCubit.getDIDAuth(
            keyId: state.keyId!,
            done: state.done!,
            uri: state.uri!,
            challenge: state.challenge!,
            domain: state.domain!);
      }
      await Navigator.of(context).pushReplacement(CredentialsListPage.route());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
