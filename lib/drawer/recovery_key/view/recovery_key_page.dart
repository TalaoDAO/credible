import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/shared/widget/mnemonic.dart';
import 'package:talao/l10n/l10n.dart';

class RecoveryKeyPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => RecoveryKeyPage(),
        settings: RouteSettings(name: '/recoveryKeyPage'),
      );

  @override
  State<RecoveryKeyPage> createState() => _RecoveryKeyPageState();
}

class _RecoveryKeyPageState extends State<RecoveryKeyPage> {
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

    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        title: l10n.recoveryKeyTitle,
        titleLeading: BackLeadingButton(),
        scrollView: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: [
                Text(
                  l10n.genPhraseInstruction,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 8.0),
                Text(
                  l10n.genPhraseExplanation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            if (_mnemonic != null && _mnemonic!.isNotEmpty)
              MnemonicDisplay(mnemonic: _mnemonic!),
          ],
        ),
      navigation: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 42,
          child: BaseButton.primary(
            context: context,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () async {
              var result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

              if (result != null) {
                var file = File(result.files.single.path!);
                var text = await file.readAsString();
                print(text);
              }
            },
            child: Text('Upload Backup File'),
          ),
        ),
      ),
    ),);
  }
}
