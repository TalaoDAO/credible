import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/drawer/recovery_credential/cubit/recovery_credential_cubit.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

class RecoveryCredentialPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              RecoveryCredentialCubit(walletCubit: context.read<WalletCubit>()),
          child: RecoveryCredentialPage(),
        ),
        settings: RouteSettings(name: '/recoveryCredentialPage'),
      );

  @override
  _RecoveryCredentialPageState createState() => _RecoveryCredentialPageState();
}

class _RecoveryCredentialPageState extends State<RecoveryCredentialPage> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    super.initState();
    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<RecoveryCredentialCubit>()
          .isMnemonicsValid(mnemonicController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.recoveryCredential,
      titleLeading: BackLeadingButton(),
      body: BlocConsumer<RecoveryCredentialCubit, RecoveryCredentialState>(
          listener: (context, state) {
        if (state.status == RecoveryCredentialStatus.success) {
          var credentialLength = state.recoveredCredentialLength;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.recoveryCredentialSuccessMessage(
                  '$credentialLength ${credentialLength! > 1 ? 'credentials' : 'credential'}'))));
        }
        if (state.status == RecoveryCredentialStatus.invalidJson) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.recoveryCredentialJSONFormatErrorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }

        if (state.status == RecoveryCredentialStatus.authError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.recoveryCredentialAuthErrorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }

        if (state.status == RecoveryCredentialStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.recoveryCredentialDefaultErrorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }
      }, builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: [
                Text(
                  l10n.recoveryCredentialPhrase,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 8.0),
                Text(
                  l10n.recoveryCredentialPhraseExplanation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            BaseTextField(
              label: l10n.recoveryMnemonicHintText,
              controller: mnemonicController,
              error: state.isTextFieldEdited && !state.isMnemonicValid
                  ? l10n.recoveryMnemonicError
                  : null,
            ),
            const SizedBox(height: 24.0),
            BaseButton.primary(
              context: context,
              textColor: Theme.of(context).colorScheme.onPrimary,
              gradient: state.isMnemonicValid
                  ? null
                  : LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.buttonDisabled,
                        Theme.of(context).colorScheme.buttonDisabled
                      ],
                    ),
              onPressed: !state.isMnemonicValid
                  ? null
                  : () async {
                      await context
                          .read<RecoveryCredentialCubit>()
                          .recoverWallet(mnemonicController.text);
                    },
              child: Text(l10n.recoveryCredentialButtonTitle),
            )
          ],
        );
      }),
    );
  }
}
