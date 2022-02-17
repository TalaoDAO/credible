import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:talao/l10n/l10n.dart';

class RecoveryPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => RecoveryPage(),
        settings: RouteSettings(name: '/recoveryPage'),
      );

  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  List<String>? _mnemonic;

  @override
  void initState() {
    super.initState();
    loadMnemonic();
  }

  Future<void> loadMnemonic() async {
    final phrase = (await SecureStorageProvider.instance.get('mnemonic'))!;
    setState(() {
      _mnemonic = phrase.split(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.onBoardingGenPhraseTitle,
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 16.0),
          Text(
            l10n.genPhraseInstruction,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Theme.of(context).colorScheme.subtitle1),
          ),
          const SizedBox(height: 8.0),
          Text(
            l10n.genPhraseExplanation,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).colorScheme.subtitle2),
          ),
          const SizedBox(height: 48.0),
          if (_mnemonic != null && _mnemonic!.isNotEmpty)
            MnemonicDisplay(mnemonic: _mnemonic!),
        ],
      ),
    );
  }
}
