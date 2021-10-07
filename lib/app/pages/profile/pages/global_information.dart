import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/pages/profile/widgets/did_display.dart';
import 'package:talao/app/shared/ui/base/palette.dart';
import 'package:talao/app/shared/ui/talao/palette.dart';
import 'package:talao/app/shared/widget/app_version.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:url_launcher/url_launcher.dart';

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
          InkWell(
            onTap: () => _launchURL('https://talao.io'),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Talao website : '),
                  Text(
                    'talao.io',
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _launchURL('mailto:contact@talao.io'),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('${localizations.personalMail} : '),
                  Text(
                    'contact@talao.io',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
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

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
