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
      title: localizations.personalTitle,
      titleLeading: BackLeadingButton(),
      body: Column(
        children: [
          DIDDisplay(),
          const SizedBox(height: 48.0),
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
