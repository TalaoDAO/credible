import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/pages/profile/widgets/did_display.dart';
import 'package:talao/app/pages/profile/widgets/display_application_contacts.dart';
import 'package:talao/app/pages/profile/widgets/issuer_verification_setting.dart';
import 'package:talao/app/shared/widget/app_version.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';

class GlobalInformationPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => GlobalInformationPage(),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.globalInformationLabel,
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IssuerVerificationSetting(),
          DIDDisplay(),
          const SizedBox(height: 16.0),
          displayTalaoContacts(),
          const SizedBox(height: 32.0),
          Center(
            child: Text(
              'DIDKit v' + DIDKitProvider.instance.getVersion(),
            ),
          ),
          const SizedBox(height: 8.0),
          AppVersion(),
        ],
      ),
    );
  }
}
