import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/pages/profile/widgets/did_display.dart';
import 'package:talao/app/shared/widget/app_version.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';

class GlobalInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.globalInformationLabel,
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DIDDisplay(),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('Talao website :'), Text('talao.io')],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('${localizations.personalMail} :'),
                Text('contact@talao.com'),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Center(
            child: Text(
              'DIDKit v' + DIDKitProvider.instance.getVersion(),
              style: Theme.of(context).textTheme.overline!,
            ),
          ),
          const SizedBox(height: 8.0),
          AppVersion(),
        ],
      ),
    );
  }
}
